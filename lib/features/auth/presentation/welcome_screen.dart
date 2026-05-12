import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Agri-TG', style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.agriculture, size: 80, color: Colors.white24),
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Une plateforme sécurisée par la blockchain pour éliminer l\'opacité financière dans les coopératives agricoles au Togo.',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 40),

                  // Problem Section
                  _buildSectionTitle('L\'opacité financière : Un frein au développement'),
                  const SizedBox(height: 16),
                  _buildStatCard('80%', 'Des coopératives tiennent leur comptabilité sur papier.', Icons.article_outlined),
                  _buildStatCard('20%', 'Des fonds font l\'objet de détournements documentés.', Icons.money_off_csred_outlined),
                  _buildStatCard('70%', 'Des membres citent le manque de transparence comme principale méfiance.', Icons.trending_down),
                  const SizedBox(height: 40),

                  // Success Stories
                  _buildSectionTitle('Histoires d\'agriculteurs'),
                  const SizedBox(height: 16),
                  _buildStoryCard(
                    'Kofi',
                    'Le désespoir de Kofi',
                    'Kofi a perdu 30% de ses récoltes à cause de "pertes" comptables inexpliquées lors de l\'achat d\'engrais.',
                    Colors.redAccent,
                  ),
                  _buildStoryCard(
                    'Abla',
                    'L\'innovation pour Abla',
                    'Abla surveille les réserves en direct. Sa confiance attire 3x plus de fonds (IFAD).',
                    AppColors.success,
                  ),
                  const SizedBox(height: 40),

                  // Solution Section
                  _buildSectionTitle('La Solution Agri-TG'),
                  const SizedBox(height: 16),
                  _buildSolutionItem('Interface Membre', 'Consultation du solde et historique en temps réel.', Icons.dashboard_outlined),
                  _buildSolutionItem('Portail de Vote', 'Décisions certifiées inviolables par Smart Contracts.', Icons.how_to_vote_outlined),
                  _buildSolutionItem('Historique Traceable', 'Chaque ligne correspond à un bloc irréversible.', Icons.history_edu_outlined),
                  const SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => context.go('/login'),
                      child: const Text('Commencer maintenant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 40),
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
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildStatCard(String val, String desc, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 32),
        title: Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
        subtitle: Text(desc),
      ),
    );
  }

  Widget _buildStoryCard(String name, String title, String content, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(side: BorderSide(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, child: Text(name[0], style: const TextStyle(color: Colors.white))),
                const SizedBox(width: 12),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionItem(String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
