import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning,
      padding: const EdgeInsets.all(4),
      child: const Text(
        'Mode hors ligne. Données non synchronisées.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }
}
