import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/blockchain_badge.dart';
import '../data/reports_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rapports')),
      body: reportsAsync.when(
        data: (reports) => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.picture_as_pdf, color: Colors.white),
                ),
                title: Text('Rapport - ${report.month}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entrées: ${formatAmount(report.totalIn)}'),
                    if (report.blockchainHash.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: BlockchainBadge(txHash: report.blockchainHash),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/reports/${report.id}'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.danger))),
      ),
    );
  }
}
