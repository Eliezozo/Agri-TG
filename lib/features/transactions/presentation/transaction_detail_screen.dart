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
    final explorerUrl = 'https://alfajores.celoscan.io/tx/${tx.blockchainHash}';

    return Scaffold(
      appBar: AppBar(title: const Text('Détails de la transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Badge blockchain cliquable
            BlockchainBadge(txHash: tx.blockchainHash),
            const SizedBox(height: 24),

            // Montant
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

            // Détails
            _buildDetailRow('Date', formatDate(tx.date)),
            const Divider(color: AppColors.textMuted),
            _buildDetailRow('Type', tx.type.toUpperCase()),
            const Divider(color: AppColors.textMuted),
            if (tx.memberName != null) ...[
              _buildDetailRow('Membre', tx.memberName!),
              const Divider(color: AppColors.textMuted),
            ],
            const SizedBox(height: 24),

            // ─── Section Hash blockchain ───
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hash de la transaction',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bgAccent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: tx.blockchainHash),
                      readOnly: true,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: AppColors.textSecondary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copier le hash',
                    icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primaryLight),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: tx.blockchainHash));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text('Hash copié dans le presse-papiers'),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bouton Celoscan
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Voir sur Celoscan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  side: const BorderSide(color: AppColors.primaryLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final url = Uri.parse(explorerUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
            const SizedBox(height: 32),

            // ─── Section Preuve d'immuabilité ───
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.primaryLight),
                      SizedBox(width: 8),
                      Text(
                        'Preuve d\'immuabilité',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cette transaction a été inscrite de manière permanente sur la blockchain Celo. '
                    'Son hash cryptographique garantit qu\'elle ne peut pas être modifiée ou supprimée, '
                    'assurant ainsi une traçabilité totale et infalsifiable.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
