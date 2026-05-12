import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/blockchain_badge.dart';
import '../data/reports_provider.dart';
import '../domain/report_model.dart';

class ReportDetailScreen extends ConsumerStatefulWidget {
  final String id; // This is the month (e.g. 2026-05)

  const ReportDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  String? _pdfHash;
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(reportDetailProvider(widget.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du rapport')),
      body: reportAsync.when(
        data: (report) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rapport ${report.month}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (report.blockchainHash.isNotEmpty)
                    BlockchainBadge(txHash: report.blockchainHash),
                ],
              ),
              const SizedBox(height: 24),

              // Stats Cards
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildRow('Total Entrées', formatAmount(report.totalIn), AppColors.success),
                      const Divider(),
                      _buildRow('Total Sorties', formatAmount(report.totalOut), AppColors.danger),
                      const Divider(),
                      _buildRow('Solde Mensuel', formatAmount(report.balance), AppColors.textPrimary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Text('Répartition par catégorie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Simple Pie Chart
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: AppColors.primary,
                        value: report.totalIn,
                        title: 'Entrées',
                        radius: 50,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        color: AppColors.danger,
                        value: report.totalOut.abs(),
                        title: 'Sorties',
                        radius: 50,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ─── Section Preuve blockchain ───
              _buildBlockchainSection(context, report),
              const SizedBox(height: 32),

              // Download Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _generating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.picture_as_pdf),
                  label: Text(_generating ? 'Génération...' : 'Télécharger le rapport certifié'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _generating ? null : () => _generateAndPrintPdf(report),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildBlockchainSection(BuildContext context, MonthlyReport report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_outlined, color: AppColors.primaryLight, size: 20),
              SizedBox(width: 8),
              Text('Certification Blockchain', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),

          if (_pdfHash != null) ...[
             _buildHashInfo(context, 'HASH DU FICHIER (SHA256)', _pdfHash!),
             const SizedBox(height: 12),
          ],

          _buildHashInfo(context, 'HASH D\'ANCRAGE (TRANSACTION)', report.blockchainHash),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              icon: const Icon(Icons.open_in_new, size: 14),
              label: const Text('Vérifier l\'authenticité sur Celoscan', style: TextStyle(fontSize: 12)),
              onPressed: () => _launchCeloscan(report.blockchainHash),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashInfo(BuildContext context, String label, String hash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgAccent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hash,
                  style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.copy, size: 14, color: AppColors.primaryLight),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: hash));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copié !'), duration: Duration(seconds: 1)));
                },
              ),
            ],
          ),
        ),
      ],
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

  Future<void> _generateAndPrintPdf(MonthlyReport report) async {
    setState(() => _generating = true);

    try {
      final pdf = pw.Document();

      // Calculate a dummy PDF hash first to show in the PDF itself if possible,
      // but usually the hash is calculated ON the final bytes.
      // We will include the blockchain anchor hash in the PDF footer.

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Header(level: 0, child: pw.Text('RAPPORT MENSUEL AGRI-TG')),
            pw.SizedBox(height: 20),
            pw.Text('Mois : ${report.month}'),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [pw.Text('Total Entrées'), pw.Text('${report.totalIn} FCFA')],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [pw.Text('Total Sorties'), pw.Text('${report.totalOut} FCFA')],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Bilan', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${report.balance} FCFA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 50),
            pw.Text('Ce rapport est certifié par la blockchain Celo.', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ],
          footer: (pw.Context context) => pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Blockchain Anchor Hash: ${report.blockchainHash}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                pw.Text('Généré le: ${DateTime.now().toString()}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
              ],
            ),
          ),
        ),
      );

      final bytes = await pdf.save();
      final hash = sha256.convert(bytes).toString();

      setState(() {
        _pdfHash = '0x$hash';
        _generating = false;
      });

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
    } catch (e) {
      setState(() => _generating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur PDF: $e')));
      }
    }
  }

  Future<void> _launchCeloscan(String hash) async {
    final url = Uri.parse("https://alfajores.celoscan.io/tx/$hash");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
