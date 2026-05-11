// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoopMemberImpl _$$CoopMemberImplFromJson(Map<String, dynamic> json) =>
    _$CoopMemberImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      cooperativeId: json['cooperativeId'] as String,
      cooperativeName: json['cooperativeName'] as String,
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$CoopMemberImplToJson(_$CoopMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'role': instance.role,
      'cooperativeId': instance.cooperativeId,
      'cooperativeName': instance.cooperativeName,
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };
