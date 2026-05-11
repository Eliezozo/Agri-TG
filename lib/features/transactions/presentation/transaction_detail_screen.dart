import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/blockchain_badge.dart';
import '../../dashboard/data/dashboard_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String id;

  const TransactionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardData = ref.read(dashboardDataProvider).value;
    final tx = dashboardData?.recentTransactions.firstWhere(
      (t) => t.id == id,
      orElse: () => dashboardData.recentTransactions.first, 
    );

    if (tx == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Transaction introuvable')));
    }

    final isPositive = tx.amount > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BlockchainBadge(),
            const SizedBox(height: 24),
            Text(
              formatAmount(tx.amount),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: isPositive ? AppColors.primary : AppColors.danger,
              ),
            ),
            const SizedBox(height: 8),
            Text(tx.description, style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            _buildDetailRow('Date', formatDate(tx.date)),
            const Divider(color: AppColors.textMuted),
            _buildDetailRow('Type', tx.type.toUpperCase()),
            const Divider(color: AppColors.textMuted),
            if (tx.memberName != null) ...[
              _buildDetailRow('Membre', tx.memberName!),
              const Divider(color: AppColors.textMuted),
            ],
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Blockchain Hash', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tx.blockchainHash,
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: AppColors.textSecondary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20, color: AppColors.primaryLight),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: tx.blockchainHash));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copié !'), backgroundColor: AppColors.primary),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Voir sur l\'explorateur'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryLight),
                onPressed: () async {
                  final url = Uri.parse('https://explorer.celo.org/tx/${tx.blockchainHash}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
