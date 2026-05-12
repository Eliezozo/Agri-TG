import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/vote_model.dart';
import 'votes_api_service.dart';

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
    try {
      final votes = await _api.getVotes(coopId);
      final box = Hive.box(_kVotesCacheBox);
      await box.put('list_$coopId', votes.map((e) => e.toJson()).toList());
      return votes;
    } on DioException catch (e) {
      final box = Hive.box(_kVotesCacheBox);
      final cached = box.get('list_$coopId');
      if (cached != null) {
        return (cached as List).map((e) => Vote.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Erreur lors de la récupération des votes.');
    }
  }

  Future<Vote> getVote(String coopId, String voteId) async {
    try {
      // Simuler l'appel API si non disponible dans le service (on filtre la liste pour l'instant)
      final votes = await getVotes(coopId);
      return votes.firstWhere((v) => v.id == voteId);
    } catch (e) {
      rethrow;
    }
  }

  Future<CastVoteResponse> castVote(String coopId, String voteId, int choice) async {
    try {
      final response = await _api.castVote(coopId, voteId, {'choice': choice});
      return response;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
