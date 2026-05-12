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
  final String id;

  const ReportDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  String? _pdfHash;
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(reportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du rapport')),
      body: reportAsync.when(
        data: (reports) {
          final report = reports.firstWhere((r) => r.id == widget.id, orElse: () => reports.first);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec badge blockchain
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rapport ${report.month}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    BlockchainBadge(txHash: report.blockchainHash),
                  ],
                ),
                const SizedBox(height: 24),

                // Carte des chiffres
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
                const SizedBox(height: 24),

                // Graphique
                const Text('Aperçu Graphique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: AppColors.success,
                          value: report.totalIn,
                          title: 'Entrées',
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        PieChartSectionData(
                          color: AppColors.danger,
                          value: report.totalOut,
                          title: 'Sorties',
                          radius: 50,
                          titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ─── Section Preuve blockchain ───
                _buildBlockchainSection(context, report),
                const SizedBox(height: 24),

                // Boutons d'action
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _generating
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.download_rounded),
                    label: Text(_generating ? 'Génération...' : 'Télécharger PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _generating ? null : () => _printPdf(report),
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

  Widget _buildBlockchainSection(BuildContext context, MonthlyReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, size: 16, color: AppColors.primaryLight),
              SizedBox(width: 8),
              Text(
                'Ancrage Blockchain',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Hash PDF
          if (_pdfHash != null) ...[
            _buildHashRow(context, 'Hash SHA-256 du PDF', _pdfHash!),
            const SizedBox(height: 10),
          ],

          // Hash blockchain
          _buildHashRow(context, 'Hash d\'ancrage (blockchain)', report.blockchainHash),
          const SizedBox(height: 14),

          // Bouton vérifier
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.verified_user_rounded, size: 15),
              label: const Text('Vérifier l\'authenticité sur Celoscan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryLight,
                side: const BorderSide(color: AppColors.primaryLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () async {
                final url = Uri.parse('https://alfajores.celoscan.io/tx/${report.blockchainHash}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashRow(BuildContext context, String label, String hash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
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
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: hash));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Hash copié'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.copy_rounded, size: 14, color: AppColors.primaryLight),
                ),
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

  Future<void> _printPdf(MonthlyReport report) async {
    setState(() => _generating = true);

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context ctx) => [
            pw.Header(
              level: 0,
              child: pw.Text('Rapport Mensuel - Agri-TG', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Mois: ${report.month}', style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Entrées:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${report.totalIn} FCFA'),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Sorties:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${report.totalOut} FCFA'),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Nombre de transactions:'),
                pw.Text('${report.transactionCount}'),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Solde:'),
                pw.Text('${report.balance} FCFA'),
              ],
            ),
          ],
          // Footer avec les deux hash blockchain
          footer: (pw.Context ctx) => pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(width: 0.5, color: PdfColors.grey400)),
            ),
            padding: const pw.EdgeInsets.only(top: 8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '── Preuve d\'immuabilité blockchain ──',
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Text('Hash SHA-256 PDF: ', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                    pw.Expanded(
                      child: pw.Text(
                        _pdfHash ?? '(calculé à la génération)',
                        style: const pw.TextStyle(fontSize: 7),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Row(
                  children: [
                    pw.Text('Hash Blockchain (Celo): ', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                    pw.Expanded(
                      child: pw.Text(report.blockchainHash, style: const pw.TextStyle(fontSize: 7)),
                    ),
                  ],
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Ce document est ancré sur la blockchain Celo Alfajores et ne peut pas être modifié.',
                  style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey500),
                ),
              ],
            ),
          ),
        ),
      );

      // Calcul du hash SHA-256 du PDF généré
      final Uint8List pdfBytes = await pdf.save();
      final digest = sha256.convert(pdfBytes);
      final pdfHash = '0x${digest.toString()}';

      setState(() {
        _pdfHash = pdfHash;
        _generating = false;
      });

      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    } catch (e) {
      setState(() => _generating = false);
    }
  }
}
