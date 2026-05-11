import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
class CoopMember with _$CoopMember {
  const factory CoopMember({
    required String id,
    required String fullName,
    required String phone,
    required String role,           // 'membre' | 'tresorier' | 'president'
    required String cooperativeId,
    required String cooperativeName,
    DateTime? joinedAt,
  }) = _CoopMember;

  factory CoopMember.fromJson(Map<String, dynamic> json) =>
      _$CoopMemberFromJson(json);
}
