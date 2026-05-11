import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../data/votes_provider.dart';
import 'widgets/vote_progress_bar.dart';
import '../../../shared/widgets/blockchain_badge.dart';

class VoteDetailScreen extends ConsumerWidget {
  final String id;

  const VoteDetailScreen({super.key, required this.id});

  Future<void> _onCastVote(
    BuildContext context,
    WidgetRef ref,
    String choice,
  ) async {
    final result = await ref.read(voteCasterProvider.notifier).castVote(id, choice);

    if (!context.mounted) return;

    if (result != null) {
      final txHash = result.txHash;
      final shortHash = '0x${txHash.substring(2, 8)}...';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            'Vote enregistré · $shortHash',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          action: SnackBarAction(
            label: 'Voir sur Celoscan',
            textColor: Colors.white70,
            onPressed: () async {
              final url = Uri.parse('https://alfajores.celoscan.io/tx/$txHash');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          duration: const Duration(seconds: 8),
        ),
      );
    } else {
      // Affiche une erreur si le vote a échoué
      final error = ref.read(voteCasterProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            error?.toString() ?? 'Erreur lors du vote.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voteAsync = ref.watch(voteDetailProvider(id));
    final voteCasterState = ref.watch(voteCasterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Détails du vote')),
      body: voteAsync.when(
        data: (vote) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
              Text(vote.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(vote.description, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              if (vote.amountThreshold != null) ...[
                Text('Montant : ${formatAmount(vote.amountThreshold!)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
              ],
              VoteProgressBar(vote: vote),
              const SizedBox(height: 32),
              if (vote.status == 'open') ...[
                const Text('Votre choix', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: voteCasterState.isLoading
                            ? null
                            : () => _onCastVote(context, ref, 'for'),
                        child: voteCasterState.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Pour'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: voteCasterState.isLoading
                            ? null
                            : () => _onCastVote(context, ref, 'against'),
                        child: const Text('Contre'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: voteCasterState.isLoading
                        ? null
                        : () => _onCastVote(context, ref, 'abstain'),
                    child: const Text("S'abstenir"),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Center(child: BlockchainBadge()),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
