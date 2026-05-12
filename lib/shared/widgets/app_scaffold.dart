import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine user role for bottom nav - simulation for hackathon
    final location = GoRouterState.of(context).matchedLocation;
    bool isPresident = location.contains('president');
    
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _getSelectedIndex(location),
          onTap: (index) => _onItemTapped(index, context, location),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Accueil'),
            const BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: 'Historique'),
            const BottomNavigationBarItem(icon: Icon(Icons.how_to_vote_outlined), activeIcon: Icon(Icons.how_to_vote), label: 'Votes'),
            if (isPresident)
              const BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Membres'),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.contains('dashboard')) return 0;
    if (location.contains('transactions')) return 1;
    if (location.contains('votes')) return 2;
    if (location.contains('profile')) return 3; // Simplified
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, String location) {
    String role = "membre";
    if (location.contains('tresorier')) role = "tresorier";
    if (location.contains('president')) role = "president";

    switch (index) {
      case 0:
        context.go('/dashboard/$role');
        break;
      case 1:
        context.go('/transactions');
        break;
      case 2:
        context.go('/votes');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
