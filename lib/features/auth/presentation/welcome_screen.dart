import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.bgDark,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Agri-TG', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.bgDark, AppColors.bgCard],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.agriculture, size: 100, color: AppColors.primary),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Redonner le pouvoir aux agriculteurs grâce à la transparence absolue.',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Une plateforme sécurisée par la blockchain pour éliminer l\'opacité financière dans les coopératives agricoles au Togo.',
                    style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 40),

                  // Problem Section
                  _buildSectionTitle('L\'opacité financière : Un frein'),
                  const SizedBox(height: 20),
                  _buildStatRow('80%', 'Comptabilité papier', Icons.article_outlined),
                  _buildStatRow('20%', 'Détournements documentés', Icons.money_off),
                  _buildStatRow('70%', 'Méfiance des membres', Icons.trending_down),

                  const SizedBox(height: 40),

                  // Stories
                  _buildSectionTitle('Histoires de succès'),
                  const SizedBox(height: 20),
                  _buildStoryCard('Abla', 'Grâce à Agri-TG, Abla surveille les réserves en direct. Sa confiance attire 3x plus de fonds (IFAD).', AppColors.primary),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () => context.go('/login'),
                      child: const Text('Accéder au Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
    );
  }

  Widget _buildStatRow(String val, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(desc, style: const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(String name, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4)),
        ],
      ),
    );
  }
}
