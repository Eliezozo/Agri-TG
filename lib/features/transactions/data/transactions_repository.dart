import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/transaction_model.dart';
import 'transactions_api_service.dart';

const _kTransactionsCacheBox = 'transactions_cache';

final transactionsApiServiceProvider = Provider<TransactionsApiService>((ref) {
  return TransactionsApiService(ref.watch(dioProvider));
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepository(ref.watch(transactionsApiServiceProvider));
});

class TransactionsRepository {
  final TransactionsApiService _api;

  TransactionsRepository(this._api);

  Future<List<Transaction>> getTransactions(
    String coopId, {
    int? page,
    int? limit,
    String? type,
  }) async {
    try {
      final txs = await _api.getTransactions(coopId, page: page, limit: limit, type: type);
      final box = Hive.box(_kTransactionsCacheBox);
      // Cache only the first page for offline use
      if ((page == null || page == 1) && type == null) {
        await box.put('list_$coopId', txs.map((e) => e.toJson()).toList());
      }
      return txs;
    } on DioException catch (e) {
      final box = Hive.box(_kTransactionsCacheBox);
      final cached = box.get('list_$coopId');
      if (cached != null) {
        return (cached as List).map((e) => Transaction.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      }
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Erreur lors de la récupération des transactions.');
    }
  }

  Future<Transaction> getTransaction(String coopId, String txId) async {
    try {
      final tx = await _api.getTransaction(coopId, txId);
      final box = Hive.box(_kTransactionsCacheBox);
      await box.put('detail_$txId', tx.toJson());
      return tx;
    } on DioException catch (e) {
      final box = Hive.box(_kTransactionsCacheBox);
      final cached = box.get('detail_$txId');
      if (cached != null) {
        return Transaction.fromJson(Map<String, dynamic>.from(cached as Map));
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<TransactionResponse> recordTransaction(String coopId, Map<String, dynamic> data) async {
    try {
      final response = await _api.recordTransaction(coopId, data);
      return response;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
