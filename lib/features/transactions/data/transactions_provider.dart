import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/data/dashboard_provider.dart';
import '../domain/transaction_model.dart';
import 'transactions_repository.dart';

part 'transactions_provider.g.dart';

class TransactionFilter {
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionFilter({this.type, this.startDate, this.endDate});
}

final transactionFilterProvider = StateProvider<TransactionFilter>((ref) => TransactionFilter());

@riverpod
Future<List<Transaction>> transactionsList(TransactionsListRef ref) async {
  final repo = ref.watch(transactionsRepositoryProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  final filter = ref.watch(transactionFilterProvider);

  return repo.getTransactions(
    coopId,
    limit: 50,
    type: filter.type,
  );
}
