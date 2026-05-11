import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/vote_model.dart';
import 'vote_progress_bar.dart';

class VoteCard extends StatelessWidget {
  final Vote vote;

  const VoteCard({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => context.go('/votes/${vote.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: vote.status == 'open' ? AppColors.primary : AppColors.textMuted,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      vote.status == 'open' ? 'Ouvert' : 'Clôturé',
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Clôt le ${formatDate(vote.closingDate)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(vote.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                vote.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              VoteProgressBar(vote: vote),
            ],
          ),
        ),
      ),
    );
  }
}
