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
    final voteResult = voteCasterState.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Détails du vote')),
      body: voteAsync.when(
        data: (vote) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statut du vote
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
                  // Badge blockchain si déjà voté et txHash disponible
                  if (voteResult != null)
                    BlockchainBadge(txHash: voteResult.txHash),
                ],
              ),
              const SizedBox(height: 16),
              Text(vote.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(vote.description, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Text('Montant : ${formatAmount(vote.amountThreshold)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              VoteProgressBar(vote: vote),
              const SizedBox(height: 32),

              // ─── Confirmation de vote enregistré ───
              if (voteResult != null) ...[
                _buildVoteConfirmation(context, voteResult.txHash),
                const SizedBox(height: 24),
              ],

              // ─── Boutons de vote ───
              if (vote.status == 'open' && voteResult == null) ...[
                const Text('Votre choix', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                            : const Text('Pour ✓'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: voteCasterState.isLoading
                            ? null
                            : () => _onCastVote(context, ref, 'against'),
                        child: const Text('Contre ✗'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: voteCasterState.isLoading
                        ? null
                        : () => _onCastVote(context, ref, 'abstain'),
                    child: const Text("S'abstenir"),
                  ),
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildVoteConfirmation(BuildContext context, String txHash) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.primaryLight.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône + titre
          const Row(
            children: [
              Icon(Icons.how_to_vote_rounded, color: AppColors.primary, size: 22),
              SizedBox(width: 10),
              Text(
                'Vote enregistré',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Message d'immuabilité
          const Text(
            'Votre vote est définitivement enregistré sur la blockchain et ne peut pas être modifié.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 14),

          // Badge blockchain avec txHash
          BlockchainBadge(txHash: txHash),
          const SizedBox(height: 12),

          // Hash tronqué affiché
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.bgAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.tag_rounded, size: 13, color: AppColors.primaryLight),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    txHash,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Bouton Celoscan
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new_rounded, size: 14),
              label: const Text('Voir sur Celoscan', style: TextStyle(fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
                side: const BorderSide(color: AppColors.primaryLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final url = Uri.parse('https://alfajores.celoscan.io/tx/$txHash');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
