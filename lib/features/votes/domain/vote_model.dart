import 'package:freezed_annotation/freezed_annotation.dart';

part 'vote_model.freezed.dart';
part 'vote_model.g.dart';

@freezed
class Vote with _$Vote {
  const factory Vote({
    required String id,
    required String title,
    required String description,
    required double amountThreshold,
    required int forCount,
    required int againstCount,
    required int abstainCount,
    required int totalMembers,
    required DateTime closingDate,
    required String status,         // 'open' | 'closed' | 'pending'
    String? currentMemberVote,      // null si pas encore voté
    String? blockchainHash,
  }) = _Vote;

  factory Vote.fromJson(Map<String, dynamic> json) =>
      _$VoteFromJson(json);
}
