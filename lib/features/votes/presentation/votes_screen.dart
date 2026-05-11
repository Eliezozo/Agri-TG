import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/votes_provider.dart';
import 'widgets/vote_card.dart';

class VotesScreen extends ConsumerWidget {
  const VotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final votesAsync = ref.watch(votesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(votesProvider),
          ),
        ],
      ),
      body: votesAsync.when(
        data: (votes) => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: votes.length,
          itemBuilder: (context, index) => VoteCard(vote: votes[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.danger))),
      ),
    );
  }
}
