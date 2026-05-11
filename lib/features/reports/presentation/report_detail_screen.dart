import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../data/reports_provider.dart';

class ReportDetailScreen extends ConsumerWidget {
  final String id;

  const ReportDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du rapport'),
      ),
      body: reportAsync.when(
        data: (reports) {
          final report = reports.firstWhere((r) => r.id == id, orElse: () => reports.first);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rapport ${report.month}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildRow('Total Entrées', formatAmount(report.totalIn), AppColors.success),
                        const Divider(),
                        _buildRow('Total Sorties', formatAmount(report.totalOut), AppColors.danger),
                        const Divider(),
                        _buildRow('Transactions', '${report.transactionCount}', AppColors.textPrimary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Aperçu Graphique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: AppColors.success,
                          value: report.totalIn,
                          title: 'In',
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          color: AppColors.danger,
                          value: report.totalOut,
                          title: 'Out',
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Télécharger PDF'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                    onPressed: () => _printPdf(report),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _printPdf(report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Rapport Mensuel - Agri-TG', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Mois: ${report.month}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Entrees: ${report.totalIn} FCFA'),
              pw.Text('Sorties: ${report.totalOut} FCFA'),
              pw.Text('Hash: ${report.blockchainHash}'),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
