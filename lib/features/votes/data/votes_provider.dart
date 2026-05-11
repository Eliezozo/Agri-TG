import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../dashboard/data/dashboard_provider.dart';
import '../domain/vote_model.dart';
import 'votes_repository.dart';

part 'votes_provider.g.dart';

/// Provider de la liste des votes avec cache Hive
@riverpod
Future<List<Vote>> votes(VotesRef ref) async {
  final repo = ref.watch(votesRepositoryProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  return repo.getVotes(coopId);
}

/// Provider du détail d'un vote
@riverpod
Future<Vote> voteDetail(VoteDetailRef ref, String voteId) async {
  final repo = ref.watch(votesRepositoryProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  return repo.getVote(coopId, voteId);
}

/// Résultat d'un vote soumis (contient le txHash blockchain)
class VoteCastResult {
  final String txHash;
  VoteCastResult(this.txHash);
}

/// Notifier gérant la soumission d'un vote
/// Retourne un VoteCastResult avec le txHash pour affichage dans la UI
@riverpod
class VoteCaster extends _$VoteCaster {
  @override
  AsyncValue<VoteCastResult?> build() => const AsyncData(null);

  Future<VoteCastResult?> castVote(String voteId, String choice) async {
    state = const AsyncLoading();

    // Mapping choix string → int (contrat blockchain: 1=Pour, 2=Contre, 3=Abstention)
    final choiceMap = {'for': 1, 'against': 2, 'abstain': 3};
    final choiceInt = choiceMap[choice] ?? 1;

    final repo = ref.read(votesRepositoryProvider);
    final coopId = ref.read(currentCoopIdProvider);

    final result = await AsyncValue.guard(() async {
      final resp = await repo.castVote(coopId, voteId, choiceInt);
      // Invalider les providers dépendants
      ref.invalidate(votesProvider);
      ref.invalidate(voteDetailProvider(voteId));
      ref.invalidate(dashboardDataProvider);
      return VoteCastResult(resp.txHash);
    });

    state = result;
    return result.valueOrNull;
  }
}
