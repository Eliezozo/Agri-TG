import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class VotesScreen extends ConsumerWidget {
  const VotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Portail de Vote", style: AppTextStyles.heading3),
              const Text("Décisions certifiées par Smart Contracts", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "En cours (2)"),
              Tab(text: "Archivés"),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildVoteCard(
                  context,
                  title: "Achat groupé semences OPV",
                  description: "Achat collectif de 350 000 FCFA pour la saison 2026",
                  closingDate: "20 mai 2026",
                  forPercent: 0.68,
                  againstPercent: 0.22,
                  votedCount: 32,
                  totalMembers: 47,
                  status: "OUVERT",
                ),
                _buildVoteCard(
                  context,
                  title: "Réparation entrepôt Sud",
                  description: "Travaux d'étanchéité pour la toiture du hangar de stockage",
                  closingDate: "25 mai 2026",
                  forPercent: 0.45,
                  againstPercent: 0.30,
                  votedCount: 12,
                  totalMembers: 47,
                  status: "OUVERT",
                ),
              ],
            ),
            const Center(child: Text("Aucun vote archivé")),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteCard(
    BuildContext context, {
    required String title,
    required String description,
    required String closingDate,
    required double forPercent,
    required double againstPercent,
    required int votedCount,
    required int totalMembers,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 3, backgroundColor: AppColors.success),
                    const SizedBox(width: 4),
                    Text(status, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success)),
                  ],
                ),
              ),
              const Spacer(),
              Text("Clôt le $closingDate", style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(description, style: AppTextStyles.bodyMuted),
          const SizedBox(height: 20),
          Row(
            children: [
              Text("Pour (${(forPercent * 100).toInt()}%)", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
              const Spacer(),
              Text("Contre (${(againstPercent * 100).toInt()}%)", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.danger)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: forPercent,
              color: AppColors.success,
              backgroundColor: AppColors.danger.withOpacity(0.2),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text("$votedCount / $totalMembers membres ont voté · 10% abstention", style: AppTextStyles.caption),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _confirmVote(context, title, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text("✓ Pour"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _confirmVote(context, title, false),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger), padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text("✗ Contre"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmVote(BuildContext context, String title, bool isFor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer votre vote"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vous votez : ${isFor ? 'POUR' : 'CONTRE'}", style: TextStyle(fontWeight: FontWeight.bold, color: isFor ? AppColors.success : AppColors.danger)),
            const SizedBox(height: 4),
            Text(title),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text(
                "⚠️ Ce vote sera enregistré de façon permanente sur la blockchain et ne pourra pas être modifié.",
                style: TextStyle(fontSize: 11, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Confirmer")),
        ],
      ),
    );
  }
}
