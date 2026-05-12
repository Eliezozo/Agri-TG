import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';

/// Badge "Validé blockchain" cliquable qui ouvre l'explorateur Celoscan.
class BlockchainBadge extends StatelessWidget {
  final String? txHash;
  final String networkName;

  const BlockchainBadge({
    super.key,
    this.txHash,
    this.networkName = 'Celo Alfajores',
  });

  Future<void> _openExplorer() async {
    if (txHash == null || txHash!.isEmpty) return;
    final url = Uri.parse('https://alfajores.celoscan.io/tx/$txHash');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tappable = txHash != null && txHash!.isNotEmpty;

    return GestureDetector(
      onTap: tappable ? _openExplorer : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              AppColors.primaryLight.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user_rounded, size: 13, color: AppColors.primaryLight),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Validé blockchain',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
                Text(
                  networkName,
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.primaryLight.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            if (tappable) ...[
              const SizedBox(width: 5),
              Icon(Icons.open_in_new_rounded, size: 10, color: AppColors.primaryLight.withValues(alpha: 0.7)),
            ],
          ],
        ),
      ),
    );
  }
}
