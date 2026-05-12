import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/vote_model.dart';

class VoteProgressBar extends StatelessWidget {
  final Vote vote;

  const VoteProgressBar({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    final total = vote.forCount + vote.againstCount + vote.abstainCount;
    final forPct = total > 0 ? vote.forCount / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Pour (${(forPct * 100).round()}%)', style: const TextStyle(fontSize: 12)),
            const Spacer(),
            Text('Contre (${((1 - forPct) * 100).round()}%)', style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: forPct,
            color: AppColors.primary,
            backgroundColor: AppColors.danger.withValues(alpha: 0.3),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$total / ${vote.totalMembers} membres ont voté',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
