import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MemberDashboardScreen extends ConsumerWidget {
  const MemberDashboardScreen({super.key});

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
            Text("Agri TG", style: AppTextStyles.heading3),
            const Text("Coopérative Agro-Lomé Est", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryBg,
              child: Text("AJ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // Solde Card
          _buildBalanceCard(),

          const SizedBox(height: 32),

          // Problem Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("Pourquoi la transparence compte", style: AppTextStyles.heading3),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProblemStatCard("📄", "80%", "Comptabilité papier"),
                _buildProblemStatCard("💸", "20%", "Détournements"),
                _buildProblemStatCard("📉", "70%", "Méfiance"),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dernières transactions", style: AppTextStyles.heading3),
                TextButton(onPressed: () => context.go('/transactions'), child: const Text("Voir tout")),
              ],
            ),
          ),
          _buildTransactionList(),

          const SizedBox(height: 24),

          // Vote Alert
          _buildVoteAlertCard(context),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Solde collectif", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text("1 248 500 FCFA", style: AppTextStyles.amount.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.verified_user, size: 10, color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text("Mis à jour · Blockchain ✓", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.account_balance, color: Colors.white24, size: 48),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatChip("Membres", "47"),
              _buildStatChip("Votes", "2"),
              _buildStatChip("Ce mois", "+218K"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildProblemStatCard(String emoji, String val, String desc) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: List.generate(3, (index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: CircleAvatar(
            backgroundColor: index == 1 ? AppColors.danger.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
            child: Icon(
              index == 1 ? Icons.arrow_downward : Icons.arrow_upward,
              color: index == 1 ? AppColors.danger : AppColors.success,
              size: 16,
            ),
          ),
          title: Text(index == 1 ? "Achat engrais" : "Cotisation", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: const Text("10 mai 2026 · 0x3f2a...", style: TextStyle(fontSize: 11)),
          trailing: Text(
            index == 1 ? "- 45 000 FCFA" : "+ 5 000 FCFA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: index == 1 ? AppColors.danger : AppColors.success,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVoteAlertCard(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/votes'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.warning,
              child: Icon(Icons.how_to_vote, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🗳️ Vote en cours", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text("Achat groupé semences OPV", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
