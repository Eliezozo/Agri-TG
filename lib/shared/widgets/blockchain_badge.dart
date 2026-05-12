import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';

class BlockchainBadge extends StatelessWidget {
  final String txHash;
  final String networkName;

  const BlockchainBadge({
    super.key,
    required this.txHash,
    this.networkName = "Celo Alfajores",
  });

  Future<void> _launchExplorer() async {
    final url = Uri.parse("https://alfajores.celoscan.io/tx/$txHash");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d\'ouvrir l\'explorateur : $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchExplorer,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.bgAccent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 14,
              color: AppColors.primaryLight,
            ),
            const SizedBox(width: 6),
            Text(
              'Validé blockchain',
              style: TextStyle(
                color: AppColors.primaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
