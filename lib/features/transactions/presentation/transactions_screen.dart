import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../data/transactions_provider.dart';
import 'widgets/transaction_tile.dart';
import 'widgets/filter_sheet.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.bgCard,
                builder: (context) => const FilterSheet(),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(transactionsListProvider.future),
        child: transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune transaction trouvée.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) => TransactionTile(transaction: transactions[index]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('Erreur: $e')),
        ),
      ),
    );
  }
}
