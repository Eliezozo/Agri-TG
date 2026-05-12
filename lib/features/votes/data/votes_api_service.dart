import 'package:dio/dio.dart';
import '../domain/vote_model.dart';

class VotesApiService {
  final Dio _dio;
  final String? baseUrl;

  VotesApiService(this._dio, {this.baseUrl});

  Future<List<Vote>> getVotes(String coopId) async {
    final response = await _dio.get('/api/coop/$coopId/votes');
    return (response.data as List)
        .map((e) => Vote.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CastVoteResponse> castVote(
    String coopId,
    String voteId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post(
      '/api/coop/$coopId/votes/$voteId/cast',
      data: body,
    );
    return CastVoteResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

class CastVoteResponse {
  final String message;
  final String txHash;

  CastVoteResponse({required this.message, required this.txHash});

  factory CastVoteResponse.fromJson(Map<String, dynamic> json) {
    return CastVoteResponse(
      message: json['message'] as String,
      txHash: json['txHash'] as String,
    );
  }
}
