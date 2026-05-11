// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      blockchainHash: json['blockchainHash'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      memberName: json['memberName'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'blockchainHash': instance.blockchainHash,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'memberName': instance.memberName,
      'category': instance.category,
    };
