// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      phone: json['phone'] as String,
      pin: json['pin'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'pin': instance.pin,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      token: json['token'] as String,
      member: CoopMember.fromJson(json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'member': instance.member,
    };
