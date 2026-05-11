import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../dashboard/data/coop_api_service.dart';
import '../../dashboard/data/dashboard_provider.dart';
import '../domain/report_model.dart';

part 'reports_provider.g.dart';

@riverpod
Future<List<MonthlyReport>> reports(ReportsRef ref) async {
  final api = ref.watch(coopApiServiceProvider);
  final coopId = ref.watch(currentCoopIdProvider);
  return api.getReports(coopId);
}
