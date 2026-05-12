import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rapport mensuel", style: AppTextStyles.heading3),
            const Text("Auto-généré · Certifié blockchain", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildMonthChip("Mars 2026", false),
                  _buildMonthChip("Avril 2026", false),
                  _buildMonthChip("Mai 2026", true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Summary Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mai 2026", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text("+218 500 FCFA", style: AppTextStyles.amount.copyWith(color: Colors.white)),
                  Text("Bilan du mois", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Colors.white24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildReportChip("Entrées", "+340 000", AppColors.success),
                      _buildReportChip("Sorties", "-121 500", AppColors.danger),
                      _buildReportChip("Txs", "47", AppColors.info),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text("Répartition des dépenses", style: AppTextStyles.heading3),
            ),

            const SizedBox(height: 24),

            Center(
              child: SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(color: AppColors.primary, value: 67.5, title: "Intrants\n67%", radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(color: AppColors.primaryLight, value: 20.6, title: "Transp.\n21%", radius: 45, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(color: AppColors.primaryXLight, value: 9.9, title: "Stock.\n10%", radius: 40, titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      PieChartSectionData(color: AppColors.divider, value: 2.0, title: "Autre\n2%", radius: 35, titleStyle: const TextStyle(fontSize: 10, color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            _buildCategoryRow("🌱 Intrants agricoles", "82 000 FCFA", "67.5%"),
            _buildCategoryRow("🚛 Transport récolte", "25 000 FCFA", "20.6%"),
            _buildCategoryRow("🏪 Stockage", "12 000 FCFA", "9.9%"),
            _buildCategoryRow("📦 Divers", "2 500 FCFA", "2.0%"),

            const SizedBox(height: 32),

            // Blockchain Certification
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified, color: AppColors.success, size: 20),
                      SizedBox(width: 8),
                      Text("Certifié blockchain", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Hash du rapport :", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  const Text("0x4f2b8c1a...a9c3", style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Ancré le 01 juin 2026 à 08:14 UTC", style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Télécharger le rapport PDF"),
                  onPressed: () {},
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
      ),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildReportChip(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9)),
      ],
    );
  }

  Widget _buildCategoryRow(String title, String amount, String pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.bgSection, borderRadius: BorderRadius.circular(4)),
            child: Text(pct, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
