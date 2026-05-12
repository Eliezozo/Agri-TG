import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../dashboard/data/dashboard_provider.dart';
import '../domain/report_model.dart';
import 'reports_repository.dart';

part 'reports_provider.g.dart';

@riverpod
Future<List<MonthlyReport>> reports(ReportsRef ref) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  // On retourne une liste car ReportsScreen s'attend à une liste.
  // En attendant un endpoint de liste, on simule avec un seul rapport ou une liste vide.
  try {
    final report = await repo.getReport(coopId, "2026-05");
    return [report];
  } catch (e) {
    return [];
  }
}

@riverpod
Future<MonthlyReport> reportDetail(ReportDetailRef ref, String month) async {
  final repo = ref.watch(reportsRepositoryProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  return repo.getReport(coopId, month);
}
