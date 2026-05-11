import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/report_model.dart';
import 'reports_api_service.dart';

export 'reports_api_service.dart' show ReportAnchorResponse;

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

  Future<List<MonthlyReport>> getReports(String coopId) async {
    const cacheKey = 'reports_list';
    try {
      final list = await _api.getReports(coopId);
      final box = Hive.box(_kReportsCacheBox);
      await box.put(cacheKey, list.map((r) => r.toJson()).toList());
      return list;
    } on DioException catch (e) {
      final box = Hive.box(_kReportsCacheBox);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return (cached as List)
            .map((e) => MonthlyReport.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<MonthlyReport> getReport(String coopId, String month) async {
    final cacheKey = 'report_$month';
    try {
      final report = await _api.getReport(coopId, month);
      final box = Hive.box(_kReportsCacheBox);
      await box.put(cacheKey, report.toJson());
      return report;
    } on DioException catch (e) {
      final box = Hive.box(_kReportsCacheBox);
      final cached = box.get(cacheKey);
      if (cached != null) {
        return MonthlyReport.fromJson(Map<String, dynamic>.from(cached as Map));
      }
      throw AppException.fromDioError(e);
    }
  }

  Future<ReportAnchorResponse> anchorReport(String coopId, String month) async {
    try {
      final resp = await _api.anchorReport(coopId, month);
      // Mettre à jour le cache après l'ancrage réussi
      final box = Hive.box(_kReportsCacheBox);
      await box.delete('report_$month');
      await box.delete('reports_list');
      return resp;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException('Échec de l\'ancrage du rapport sur la blockchain.');
    }
  }
}
