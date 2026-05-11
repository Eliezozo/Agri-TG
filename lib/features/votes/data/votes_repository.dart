import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/vote_model.dart';
import 'votes_api_service.dart';

export 'votes_api_service.dart' show VoteCastResponse;

const _kVotesCacheBox = 'votes_cache';

final votesApiServiceProvider = Provider<VotesApiService>((ref) {
  return VotesApiService(ref.watch(dioProvider));
});

final votesRepositoryProvider = Provider<VotesRepository>((ref) {
  return VotesRepository(ref.watch(votesApiServiceProvider));
});

class VotesRepository {
  final VotesApiService _api;

  VotesRepository(this._api);

  Future<List<Vote>> getVotes(String coopId) async {
    const cacheKey = 'votes_list';
    try {
      final list = await _api.getVotes(coopId);
      final box = Hive.box(_kVotesCacheBox);
      await box.put(cacheKey, list.map((v) => v.toJson()).toList());
      return list;
    } on DioException catch (e) {
      final box = Hive.box(_kVotesCacheBox);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map((e) => Vote.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<Vote> getVote(String coopId, String voteId) async {
    final cacheKey = 'vote_$voteId';
    try {
      final vote = await _api.getVote(coopId, voteId);
      final box = Hive.box(_kVotesCacheBox);
      await box.put(cacheKey, vote.toJson());
      return vote;
    } on DioException catch (e) {
      final box = Hive.box(_kVotesCacheBox);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return Vote.fromJson(Map<String, dynamic>.from(cached as Map));
      }
      throw AppException.fromDioError(e);
    }
  }

  /// Soumet un vote et retourne la réponse incluant le txHash blockchain
  Future<VoteCastResponse> castVote(
    String coopId,
    String voteId,
    int choice,
  ) async {
    try {
      final resp = await _api.castVote(coopId, voteId, {'choice': choice});
      // Invalider le cache de ce vote spécifique
      final box = Hive.box(_kVotesCacheBox);
      await box.delete('vote_$voteId');
      await box.delete('votes_list');
      return resp;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Échec de la soumission du vote.');
    }
  }
}
