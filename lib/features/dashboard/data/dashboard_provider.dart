import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../transactions/domain/transaction_model.dart';
import 'coop_api_service.dart';
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
  final api = ref.watch(coopApiServiceProvider);

  ref.keepAlive();
  final timer = Timer.periodic(const Duration(seconds: 30), (_) => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  final balance = await api.getBalance(coopId);
  final recentTx = await api.getTransactions(coopId, limit: 5);
  final stats = await api.getStats(coopId);

  return DashboardData(
    balance: balance,
    recentTransactions: recentTx,
    stats: stats,
  );
}
