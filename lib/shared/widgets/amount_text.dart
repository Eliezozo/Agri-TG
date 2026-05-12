import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';

class AmountText extends StatelessWidget {
  final double amount;
  final bool small;

  const AmountText({super.key, required this.amount, this.small = false});

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = isPositive ? AppColors.success : AppColors.danger;
    final prefix = isPositive ? "+ " : "- ";

    return Text(
      "$prefix${formatAmount(amount.abs())}",
      style: TextStyle(
        fontSize: small ? 16 : 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
