// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoteImpl _$$VoteImplFromJson(Map<String, dynamic> json) => _$VoteImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amountThreshold: (json['amountThreshold'] as num).toDouble(),
      forCount: (json['forCount'] as num).toInt(),
      againstCount: (json['againstCount'] as num).toInt(),
      abstainCount: (json['abstainCount'] as num).toInt(),
      totalMembers: (json['totalMembers'] as num).toInt(),
      closingDate: DateTime.parse(json['closingDate'] as String),
      status: json['status'] as String,
      currentMemberVote: json['currentMemberVote'] as String?,
      blockchainHash: json['blockchainHash'] as String?,
    );

Map<String, dynamic> _$$VoteImplToJson(_$VoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'amountThreshold': instance.amountThreshold,
      'forCount': instance.forCount,
      'againstCount': instance.againstCount,
      'abstainCount': instance.abstainCount,
      'totalMembers': instance.totalMembers,
      'closingDate': instance.closingDate.toIso8601String(),
      'status': instance.status,
      'currentMemberVote': instance.currentMemberVote,
      'blockchainHash': instance.blockchainHash,
    };
