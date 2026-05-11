import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';

class StatGrid extends StatelessWidget {
  final Map<String, dynamic> stats;

  const StatGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Membres actifs', '${stats["activeMembers"]}', AppColors.info),
        _buildStatCard('Votes ouverts', '${stats["openVotes"]}', AppColors.warning),
        _buildStatCard('Entrées du mois', formatAmount(stats["monthlyIn"]), AppColors.success),
        _buildStatCard('Sorties du mois', formatAmount(stats["monthlyOut"]), AppColors.danger),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const Spacer(),
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
