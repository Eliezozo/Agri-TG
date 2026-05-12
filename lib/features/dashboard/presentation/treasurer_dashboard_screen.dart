import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'member_dashboard_screen.dart';

class TreasurerDashboardScreen extends ConsumerWidget {
  const TreasurerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.agriculture, color: AppColors.primary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Agri TG", style: AppTextStyles.heading3),
                const SizedBox(width: 8),
                _buildRoleBadge(),
              ],
            ),
            const Text("Coopérative Agro-Lomé Est", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          const MemberDashboardScreen().buildBalanceCard(), // Reusing logic from member dashboard

          const SizedBox(height: 24),

          _buildFinancialSummary(),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("Dernières transactions", style: AppTextStyles.heading3),
          ),
          const MemberDashboardScreen().buildTransactionList(),

          const SizedBox(height: 40),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Nouvelle transaction", style: AppTextStyles.buttonText),
        onPressed: () => _showNewTransactionSheet(context),
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.roleTresorier.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.roleTresorier.withOpacity(0.3)),
      ),
      child: const Text("TRÉSORIER", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.roleTresorier)),
    );
  }

  Widget _buildFinancialSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Résumé mai 2026", style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFinanceChip("Entrées", "+340 000 FCFA", AppColors.success),
              const SizedBox(width: 12),
              _buildFinanceChip("Sorties", "-121 500 FCFA", AppColors.danger),
            ],
          ),
          const SizedBox(height: 16),
          Text("Bilan : +218 500 FCFA", style: AppTextStyles.heading3.copyWith(color: AppColors.success)),
          const Text("47 transactions validées · Certifié blockchain", style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf, size: 16),
              label: const Text("Générer rapport PDF"),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceChip(String label, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  void _showNewTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nouvelle transaction", style: AppTextStyles.heading2),
            const SizedBox(height: 24),
            const TextField(decoration: InputDecoration(labelText: "Description")),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: "Montant (FCFA)"), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: ["Cotisation", "Achat intrant", "Prime vente", "Autre"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (_) {},
              decoration: const InputDecoration(labelText: "Type de transaction"),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Certifier sur la blockchain"),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: Text("Cette transaction sera immuable une fois validée", style: TextStyle(fontSize: 10, color: AppColors.textMuted))),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Add these helper methods to MemberDashboardScreen to allow reuse:
extension DashboardHelpers on MemberDashboardScreen {
  Widget buildBalanceCard() => _buildBalanceCard();
  Widget buildTransactionList() => _buildTransactionList();
}
