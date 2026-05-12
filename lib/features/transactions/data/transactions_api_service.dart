import 'package:dio/dio.dart';
import '../domain/transaction_model.dart';

/// Implémentation manuelle pour contourner l'erreur retrofit_generator
class TransactionsApiService {
  final Dio _dio;
  final String? baseUrl;

  TransactionsApiService(this._dio, {this.baseUrl});

  Future<List<Transaction>> getTransactions(
    String coopId, {
    int? page,
    int? limit,
    String? type,
  }) async {
    final response = await _dio.get(
      '/api/coop/$coopId/transactions',
      queryParameters: {
        if (page != null) 'page': page,
        if (limit != null) 'limit': limit,
        if (type != null) 'type': type,
      },
    );
    return (response.data as List)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Transaction> getTransaction(
    String coopId,
    String txId,
  ) async {
    final response = await _dio.get('/api/coop/$coopId/transactions/$txId');
    return Transaction.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TransactionResponse> recordTransaction(
    String coopId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post(
      '/api/coop/$coopId/transactions',
      data: body,
    );
    return TransactionResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

class TransactionResponse {
  final String message;
  final String txHash;
  final Transaction transaction;

  TransactionResponse({
    required this.message,
    required this.txHash,
    required this.transaction,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      message: json['message'] as String,
      txHash: json['txHash'] as String,
      transaction: Transaction.fromJson(json['transaction'] as Map<String, dynamic>),
    );
  }
}
