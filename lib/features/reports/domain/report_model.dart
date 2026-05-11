import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required String id,
    required String month,          // ex: "2026-04"
    required double totalIn,
    required double totalOut,
    required double balance,
    required int transactionCount,
    required Map<String, double> byCategory,
    required String blockchainHash,
    required DateTime generatedAt,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}
