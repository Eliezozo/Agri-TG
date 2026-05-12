import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/blockchain_badge.dart';
import '../data/transactions_provider.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Historique traceable", style: AppTextStyles.heading3),
            const Text("Registre blockchain immuable", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.bgSection,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher par description, montant...",
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip("Tous", true),
                _buildFilterChip("Cotisations", false),
                _buildFilterChip("Achats", false),
                _buildFilterChip("Primes", false),
                _buildFilterChip("Ce mois", false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 15,
              separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (context, index) {
                final isPositive = index % 3 != 0;
                return ListTile(
                  onTap: () => context.push('/transactions/tx_$index'),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isPositive ? AppColors.success.withOpacity(0.1) : AppColors.danger.withOpacity(0.1),
                    child: Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? AppColors.success : AppColors.danger,
                      size: 16,
                    ),
                  ),
                  title: Row(
                    children: [
                      const Text("Cotisation — AMAVI Jojo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const Spacer(),
                      Text(
                        isPositive ? "+ 5 000" : "- 12 500",
                        style: TextStyle(fontWeight: FontWeight.bold, color: isPositive ? AppColors.success : AppColors.danger),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("10 mai 2026", style: TextStyle(fontSize: 11)),
                          const Spacer(),
                          const Text("FCFA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("0x3f2a...c1 · Bloc #4829", style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace')),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: const Row(
                              children: [
                                Icon(Icons.verified, size: 8, color: AppColors.success),
                                SizedBox(width: 2),
                                Text("BC", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.success)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.textPrimary)),
        selected: selected,
        onSelected: (_) {},
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.divider)),
      ),
    );
  }
}
