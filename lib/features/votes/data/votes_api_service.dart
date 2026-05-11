import 'package:dio/dio.dart';
import '../../votes/domain/vote_model.dart';

/// Service API pour les votes - wraps Dio directement
class VotesApiService {
  final Dio _dio;

  VotesApiService(this._dio);

  Future<List<Vote>> getVotes(String coopId) async {
    final resp = await _dio.get('/api/coop/$coopId/votes');
    final list = resp.data as List<dynamic>;
    return list.map((e) => Vote.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Vote> getVote(String coopId, String voteId) async {
    final resp = await _dio.get('/api/coop/$coopId/votes/$voteId');
    return Vote.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<VoteCastResponse> castVote(
    String coopId,
    String voteId,
    Map<String, dynamic> body,
  ) async {
    final resp = await _dio.post(
      '/api/coop/$coopId/votes/$voteId/cast',
      data: body,
    );
    return VoteCastResponse.fromJson(resp.data as Map<String, dynamic>);
  }
}

class VoteCastResponse {
  final String txHash;
  final String message;

  VoteCastResponse({required this.txHash, required this.message});

  factory VoteCastResponse.fromJson(Map<String, dynamic> json) => VoteCastResponse(
        txHash: json['txHash'] as String,
        message: json['message'] as String? ?? 'Vote enregistré',
      );
}
