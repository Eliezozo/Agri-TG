import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/report_model.dart';
import 'reports_api_service.dart';

const _kReportsCacheBox = 'reports_cache';

final reportsApiServiceProvider = Provider<ReportsApiService>((ref) {
  return ReportsApiService(ref.watch(dioProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(reportsApiServiceProvider));
});

class ReportsRepository {
  final ReportsApiService _api;

  ReportsRepository(this._api);

  Future<MonthlyReport> getReport(String coopId, String month) async {
    try {
      final report = await _api.getReport(coopId, month);
      final box = Hive.box(_kReportsCacheBox);
      await box.put('${coopId}_$month', report.toJson());
      return report;
    } on DioException catch (e) {
      final box = Hive.box(_kReportsCacheBox);
      final cached = box.get('${coopId}_$month');
      if (cached != null) {
        return MonthlyReport.fromJson(Map<String, dynamic>.from(cached as Map));
      }
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Erreur lors de la récupération du rapport.');
    }
  }

  Future<AnchorReportResponse> anchorReport(String coopId, String month) async {
    try {
      final response = await _api.anchorReport(coopId, month);
      return response;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
