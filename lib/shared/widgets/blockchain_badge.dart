import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BlockchainBadge extends StatelessWidget {
  const BlockchainBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bgAccent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.verified, size: 10, color: AppColors.primaryLight),
          SizedBox(width: 4),
          Text(
            'Validé blockchain',
            style: TextStyle(fontSize: 9, color: AppColors.primaryLight),
          ),
        ],
      ),
    );
  }
}
