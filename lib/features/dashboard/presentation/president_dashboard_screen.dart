import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'member_dashboard_screen.dart';

class PresidentDashboardScreen extends ConsumerWidget {
  const PresidentDashboardScreen({super.key});

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
          const MemberDashboardScreen().buildBalanceCard(),

          const SizedBox(height: 24),

          _buildControlPanel(context),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("Membres actifs (47)", style: AppTextStyles.heading3),
          ),
          const SizedBox(height: 12),
          _buildMemberList(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextButton(onPressed: () {}, child: const Text("Voir tous les membres →")),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.rolePresident.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.rolePresident.withOpacity(0.3)),
      ),
      child: const Text("PRÉSIDENT", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.rolePresident)),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryXLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Panneau de contrôle", style: AppTextStyles.heading3),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(Icons.how_to_vote, "Créer vote", AppColors.primary, () => context.go('/votes')),
              _buildActionButton(Icons.people, "Gérer", AppColors.accentLight, () {}),
              _buildActionButton(Icons.bar_chart, "Analytics", AppColors.info, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    final members = [
      {"name": "Kokou Agbénou", "role": "MEMBRE", "date": "Jan. 2024"},
      {"name": "Abla Dzifa", "role": "MEMBRE", "date": "Mars 2024"},
      {"name": "Koffi Mensah", "role": "TRÉSORIER", "date": "Oct. 2023"},
    ];

    return Column(
      children: members.map((m) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        leading: CircleAvatar(
          backgroundColor: AppColors.divider,
          child: Text(m['name']![0], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        title: Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text("Depuis ${m['date']}", style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right, size: 18),
      )).toList(),
    );
  }
}
