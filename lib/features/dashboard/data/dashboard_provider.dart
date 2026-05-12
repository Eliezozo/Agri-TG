import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/domain/transaction_model.dart';
import '../../transactions/data/transactions_repository.dart';
import '../../auth/data/auth_provider.dart';

part 'dashboard_provider.g.dart';

class DashboardData {
  final double balance;
  final List<Transaction> recentTransactions;
  final Map<String, dynamic> stats;

  DashboardData({required this.balance, required this.recentTransactions, required this.stats});
}

final currentCoopIdProvider = Provider<String>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  return user?.cooperativeId ?? 'coop-001';
});

@riverpod
Future<DashboardData> dashboardData(DashboardDataRef ref) async {
  final coopId = ref.watch(currentCoopIdProvider);
  final repo = ref.watch(transactionsRepositoryProvider);

  ref.keepAlive();
  Timer.periodic(const Duration(seconds: 30), (_) => ref.invalidateSelf());

  final balance = await repo.getBalance(coopId);
  final recentTx = await repo.getTransactions(coopId, limit: 5);

  return DashboardData(
    balance: balance,
    recentTransactions: recentTx,
    stats: {
      'activeMembers': 120,
      'openVotes': 2,
      'monthlyIn': 350000.0,
      'monthlyOut': 150000.0,
    },
  );
}
