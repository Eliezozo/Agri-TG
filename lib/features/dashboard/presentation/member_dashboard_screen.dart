import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MemberDashboardScreen extends ConsumerWidget {
  const MemberDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text("Agri-TG · Membre"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // Balance Card
          _buildBalanceCard(),

          const SizedBox(height: 32),

          Text("Résumé mensuel", style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox("47", "Membres", Icons.people_outline),
              const SizedBox(width: 16),
              _buildStatBox("2", "Votes", Icons.how_to_vote_outlined),
            ],
          ),

          const SizedBox(height: 32),

          Text("Dernières activités", style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          _buildActivityItem("Cotisation reçue", "10 mai 2026", "+ 5 000 FCFA", AppColors.success),
          _buildActivityItem("Achat engrais", "08 mai 2026", "- 45 000 FCFA", AppColors.danger),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SOLDE COLLECTIF", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          const Text("1 248 500 FCFA", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.black24, borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(Icons.verified, size: 12, color: Colors.white),
                    SizedBox(width: 6),
                    Text("SYNCHRONISÉ BLOCKCHAIN", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String val, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 20),
            const SizedBox(height: 12),
            Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String date, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 20, child: Icon(Icons.history, color: color, size: 18)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(date, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ]),
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
