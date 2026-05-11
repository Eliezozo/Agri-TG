import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../transactions/domain/transaction_model.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transactions récentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.go('/transactions'),
              child: const Text('Voir tout'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            final isPositive = tx.amount > 0;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isPositive ? AppColors.bgAccent : const Color(0xFF3D1A0D),
                child: Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? AppColors.primary : AppColors.danger,
                  size: 16,
                ),
              ),
              title: Text(tx.description),
              subtitle: Text(
                '${formatDate(tx.date)} · ${tx.blockchainHash.substring(0, 8)}...',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              trailing: Text(
                formatAmount(tx.amount),
                style: TextStyle(
                  color: isPositive ? AppColors.primary : AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => context.go('/transactions/${tx.id}'),
            );
          },
        ),
      ],
    );
  }
}
