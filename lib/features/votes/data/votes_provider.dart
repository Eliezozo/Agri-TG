import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../dashboard/data/coop_api_service.dart';
import '../../dashboard/data/dashboard_provider.dart';
import '../domain/vote_model.dart';

part 'votes_provider.g.dart';

@riverpod
Future<List<Vote>> votes(VotesRef ref) async {
  final api = ref.watch(coopApiServiceProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  final dynamicList = await api.getVotes(coopId);
  return dynamicList.map((e) => e as Vote).toList();
}

@riverpod
Future<Vote> voteDetail(VoteDetailRef ref, String voteId) async {
  final api = ref.watch(coopApiServiceProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  return await api.getVote(coopId, voteId) as Vote;
}

@riverpod
class VoteCaster extends _$VoteCaster {
  @override
  Future<void> build() async {}

  Future<void> castVote(String voteId, String choice) async {
    state = const AsyncLoading();
    final api = ref.read(coopApiServiceProvider);
    final coopId = ref.read(currentCoopIdProvider);
    state = await AsyncValue.guard(() async {
      await api.castVote(coopId, voteId, choice);
      ref.invalidate(votesProvider);
      ref.invalidate(voteDetailProvider(voteId));
    });
  }
}
