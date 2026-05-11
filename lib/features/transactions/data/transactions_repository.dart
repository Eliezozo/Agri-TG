import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/transaction_model.dart';
import 'transactions_api_service.dart';

export 'transactions_api_service.dart'
    show BalanceResponse, TransactionCreateResponse;

const _kTxCacheBox = 'transactions_cache';
const _kBalanceCacheKey = 'balance_cache';

final transactionsApiServiceProvider = Provider<TransactionsApiService>((ref) {
  return TransactionsApiService(ref.watch(dioProvider));
});

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepository(ref.watch(transactionsApiServiceProvider));
});

class TransactionsRepository {
  final TransactionsApiService _api;

  TransactionsRepository(this._api);

  Future<double> getBalance(String coopId) async {
    try {
      final resp = await _api.getBalance(coopId);
      final box = Hive.box(_kTxCacheBox);
      await box.put(_kBalanceCacheKey, resp.balance);
      return resp.balance;
    } on DioException catch (e) {
      final box = Hive.box(_kTxCacheBox);
      final cached = box.get(_kBalanceCacheKey);
      if (cached != null) return (cached as num).toDouble();
      throw AppException.fromDioError(e);
    }
  }

  Future<List<Transaction>> getTransactions(
    String coopId, {
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    final cacheKey = 'txs_${coopId}_p${page}_t${type ?? "all"}';
    try {
      final list = await _api.getTransactions(coopId, page: page, limit: limit, type: type);
      final box = Hive.box(_kTxCacheBox);
      await box.put(cacheKey, list.map((t) => t.toJson()).toList());
      return list;
    } on DioException catch (e) {
      final box = Hive.box(_kTxCacheBox);
      final cached = box.get(cacheKey);
      if (cached != null) {
        final list = (cached as List)
            .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        return list;
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<Transaction> getTransaction(String coopId, String txId) async {
    final cacheKey = 'tx_${coopId}_$txId';
    try {
      final tx = await _api.getTransaction(coopId, txId);
      final box = Hive.box(_kTxCacheBox);
      await box.put(cacheKey, tx.toJson());
      return tx;
    } on DioException catch (e) {
      final box = Hive.box(_kTxCacheBox);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return Transaction.fromJson(Map<String, dynamic>.from(cached as Map));
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<TransactionCreateResponse> createTransaction(
    String coopId, {
    required String type,
    required double amount,
    required String description,
  }) async {
    try {
      return await _api.createTransaction(coopId, {
        'type': type,
        'amount': amount,
        'description': description,
      });
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Échec de la création de la transaction.');
    }
  }
}
