import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../data/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const SizedBox.shrink();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                user.role.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primaryLight),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Téléphone'),
                subtitle: Text(user.phone),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Coopérative ID'),
                subtitle: Text(user.cooperativeId),
              ),
              const Divider(),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
    );
  }
}
