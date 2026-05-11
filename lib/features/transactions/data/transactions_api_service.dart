import 'package:dio/dio.dart';
import '../../transactions/domain/transaction_model.dart';

/// Service API pour les transactions - wraps Dio directement
class TransactionsApiService {
  final Dio _dio;

  TransactionsApiService(this._dio);

  Future<BalanceResponse> getBalance(String coopId) async {
    final resp = await _dio.get('/api/coop/$coopId/balance');
    return BalanceResponse.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<Transaction>> getTransactions(
    String coopId, {
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    final resp = await _dio.get(
      '/api/coop/$coopId/transactions',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
      },
    );
    final list = resp.data as List<dynamic>;
    return list.map((e) => Transaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Transaction> getTransaction(String coopId, String txId) async {
    final resp = await _dio.get('/api/coop/$coopId/transactions/$txId');
    return Transaction.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<TransactionCreateResponse> createTransaction(
    String coopId,
    Map<String, dynamic> body,
  ) async {
    final resp = await _dio.post('/api/coop/$coopId/transactions', data: body);
    return TransactionCreateResponse.fromJson(resp.data as Map<String, dynamic>);
  }
}

class BalanceResponse {
  final double balance;
  final String updatedAt;

  BalanceResponse({required this.balance, required this.updatedAt});

  factory BalanceResponse.fromJson(Map<String, dynamic> json) => BalanceResponse(
        balance: (json['balance'] as num).toDouble(),
        updatedAt: json['updatedAt'] as String,
      );
}

class TransactionCreateResponse {
  final String txHash;
  final Transaction transaction;

  TransactionCreateResponse({required this.txHash, required this.transaction});

  factory TransactionCreateResponse.fromJson(Map<String, dynamic> json) =>
      TransactionCreateResponse(
        txHash: json['txHash'] as String,
        transaction: Transaction.fromJson(json['transaction'] as Map<String, dynamic>),
      );
}
