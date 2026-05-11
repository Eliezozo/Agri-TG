import 'package:dio/dio.dart';
import '../../reports/domain/report_model.dart';

/// Service API pour les rapports - wraps Dio directement
class ReportsApiService {
  final Dio _dio;

  ReportsApiService(this._dio);

  Future<List<MonthlyReport>> getReports(String coopId) async {
    final resp = await _dio.get('/api/coop/$coopId/reports');
    final list = resp.data as List<dynamic>;
    return list.map((e) => MonthlyReport.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MonthlyReport> getReport(String coopId, String month) async {
    final resp = await _dio.get('/api/coop/$coopId/reports/$month');
    return MonthlyReport.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<ReportAnchorResponse> anchorReport(String coopId, String month) async {
    final resp = await _dio.post('/api/coop/$coopId/reports/$month/anchor');
    return ReportAnchorResponse.fromJson(resp.data as Map<String, dynamic>);
  }
}

class ReportAnchorResponse {
  final String txHash;
  final String pdfHash;
  final String message;

  ReportAnchorResponse({
    required this.txHash,
    required this.pdfHash,
    required this.message,
  });

  factory ReportAnchorResponse.fromJson(Map<String, dynamic> json) =>
      ReportAnchorResponse(
        txHash: json['txHash'] as String,
        pdfHash: json['pdfHash'] as String,
        message: json['message'] as String? ?? 'Rapport ancré',
      );
}
