import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/transactions_provider.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = ref.read(transactionFilterProvider).type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtrer les transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Text('Type', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Tous', 'Cotisation', 'Achat', 'Prime'].map((type) {
              final val = type == 'Tous' ? null : type.toLowerCase();
              final isSelected = _selectedType == val;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: AppColors.primary,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedType = val);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                ref.read(transactionFilterProvider.notifier).state = TransactionFilter(type: _selectedType);
                Navigator.pop(context);
              },
              child: const Text('Appliquer les filtres'),
            ),
          ),
        ],
      ),
    );
  }
}
