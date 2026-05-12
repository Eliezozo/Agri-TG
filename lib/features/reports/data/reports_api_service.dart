import 'package:dio/dio.dart';
import '../domain/report_model.dart';

class ReportsApiService {
  final Dio _dio;
  final String? baseUrl;

  ReportsApiService(this._dio, {this.baseUrl});

  Future<MonthlyReport> getReport(
    String coopId,
    String month,
  ) async {
    final response = await _dio.get('/api/coop/$coopId/reports/$month');
    return MonthlyReport.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AnchorReportResponse> anchorReport(
    String coopId,
    String month,
  ) async {
    final response = await _dio.post('/api/coop/$coopId/reports/$month/anchor');
    return AnchorReportResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

class AnchorReportResponse {
  final String message;
  final String txHash;
  final String pdfHash;

  AnchorReportResponse({
    required this.message,
    required this.txHash,
    required this.pdfHash,
  });

  factory AnchorReportResponse.fromJson(Map<String, dynamic> json) {
    return AnchorReportResponse(
      message: json['message'] as String,
      txHash: json['txHash'] as String,
      pdfHash: json['pdfHash'] as String,
    );
  }
}
