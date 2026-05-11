import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class CoopSelectionScreen extends StatelessWidget {
  const CoopSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Coopératives')),
      body: ListView.builder(
        itemCount: 2, // Mock data
        itemBuilder: (context, index) {
          final isFirst = index == 0;
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.group, color: Colors.white),
            ),
            title: Text(isFirst ? 'Coopérative agricole de Kpalimé' : 'Coopérative de Sokodé'),
            subtitle: Text(isFirst ? '120 membres' : '45 membres'),
            onTap: () {
              context.go('/dashboard');
            },
          );
        },
      ),
    );
  }
}
