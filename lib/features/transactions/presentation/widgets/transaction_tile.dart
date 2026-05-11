import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPositive ? AppColors.bgAccent : const Color(0xFF3D1A0D),
        child: Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? AppColors.primary : AppColors.danger,
          size: 16,
        ),
      ),
      title: Text(transaction.description),
      subtitle: Text(
        '${formatDate(transaction.date)} · ${transaction.blockchainHash.substring(0, 8)}...',
        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
      ),
      trailing: Text(
        formatAmount(transaction.amount),
        style: TextStyle(
          color: isPositive ? AppColors.primary : AppColors.danger,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => context.go('/transactions/${transaction.id}'),
    );
  }
}
