// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyReportImpl _$$MonthlyReportImplFromJson(Map<String, dynamic> json) =>
    _$MonthlyReportImpl(
      id: json['id'] as String,
      month: json['month'] as String,
      totalIn: (json['totalIn'] as num).toDouble(),
      totalOut: (json['totalOut'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      byCategory: (json['byCategory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      blockchainHash: json['blockchainHash'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$MonthlyReportImplToJson(_$MonthlyReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'month': instance.month,
      'totalIn': instance.totalIn,
      'totalOut': instance.totalOut,
      'balance': instance.balance,
      'transactionCount': instance.transactionCount,
      'byCategory': instance.byCategory,
      'blockchainHash': instance.blockchainHash,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };
