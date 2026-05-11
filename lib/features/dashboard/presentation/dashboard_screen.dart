import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../data/dashboard_provider.dart';
import 'widgets/balance_card.dart';
import 'widgets/stat_grid.dart';
import 'widgets/recent_transactions_list.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(dashboardDataProvider),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardDataProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BalanceCard(balance: data.balance),
                const SizedBox(height: 24),
                StatGrid(stats: data.stats),
                const SizedBox(height: 24),
                RecentTransactionsList(transactions: data.recentTransactions),
              ],
            ),
          ),
        ),
        loading: () => const _DashboardSkeleton(),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $e', style: const TextStyle(color: AppColors.danger)),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardDataProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgAccent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(height: 150, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
                const SizedBox(width: 12),
                Expanded(child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
                const SizedBox(width: 12),
                Expanded(child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
          ],
        ),
      ),
    );
  }
}
