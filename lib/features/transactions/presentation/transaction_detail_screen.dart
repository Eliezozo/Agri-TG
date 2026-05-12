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
    final dashboardData = ref.read(dashboardDataProvider).valueOrNull;
    // Note: In a real app, we would fetch the specific transaction if not in recent list
    final tx = dashboardData?.recentTransactions.firstWhere(
      (t) => t.id == id,
      orElse: () => dashboardData.recentTransactions.first,
    );

    if (tx == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: const Center(child: Text('Transaction introuvable')),
      );
    }

    final isPositive = tx.amount > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Clickable Blockchain Badge
            BlockchainBadge(txHash: tx.blockchainHash),
            const SizedBox(height: 32),

            // Amount Display
            Text(
              formatAmount(tx.amount),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isPositive ? AppColors.success : AppColors.danger,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tx.description,
              style: const TextStyle(fontSize: 18, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Date', formatDate(tx.date)),
                    const Divider(),
                    _buildInfoRow('Type', tx.type.toUpperCase()),
                    const Divider(),
                    _buildInfoRow('ID Interne', tx.id),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Blockchain Proof Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PREUVE BLOCKCHAIN',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 12),

            // Read-only hash field
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.textMuted.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        tx.blockchainHash,
                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18, color: AppColors.primaryLight),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: tx.blockchainHash));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hash copié !'), duration: Duration(seconds: 1)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Celoscan Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('Voir sur Celoscan'),
                onPressed: () => _launchCeloscan(tx.blockchainHash),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  side: const BorderSide(color: AppColors.primaryLight),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Immutability Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Preuve d\'immuabilité', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cette transaction est gravée dans la blockchain Celo. Elle ne peut être ni modifiée ni supprimée, garantissant une transparence totale de la gestion des fonds.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _launchCeloscan(String hash) async {
    final url = Uri.parse("https://alfajores.celoscan.io/tx/$hash");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
