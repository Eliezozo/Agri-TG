import 'package:flutter/material.dart';

abstract class AppColors {
  // Vert principal (couleur dominante du site Agri TG)
  static const Color primary       = Color(0xFF2D6A4F); // Vert foncé forêt
  static const Color primaryLight  = Color(0xFF52B788); // Vert moyen
  static const Color primaryXLight = Color(0xFF95D5B2); // Vert clair
  static const Color primaryBg     = Color(0xFFD8F3DC); // Vert très clair (bg cards)

  // Accents
  static const Color accent        = Color(0xFF1B4332); // Vert très foncé (headers)
  static const Color accentLight   = Color(0xFF40916C); // Vert intermédiaire

  // Statuts sémantiques
  static const Color success       = Color(0xFF52B788); // Entrée / positif
  static const Color danger        = Color(0xFFE63946); // Sortie / négatif / alerte
  static const Color warning       = Color(0xFFFFB703); // Avertissement
  static const Color info          = Color(0xFF457B9D); // Information

  // Neutres
  static const Color bgLight       = Color(0xFFF8FFF9); // Fond principal clair
  static const Color bgCard        = Color(0xFFFFFFFF); // Fond cartes
  static const Color bgSection     = Color(0xFFF1F8F3); // Fond sections alternées
  static const Color textPrimary   = Color(0xFF1B4332); // Texte principal
  static const Color textSecondary = Color(0xFF52796F); // Texte secondaire
  static const Color textMuted     = Color(0xFF95B7A8); // Texte atténué
  static const Color divider       = Color(0xFFCAE8D5); // Séparateurs

  // Rôles (badges couleur)
  static const Color roleMembre    = Color(0xFF52B788); // Vert
  static const Color roleTresorier = Color(0xFF457B9D); // Bleu
  static const Color rolePresident  = Color(0xFF2D6A4F); // Vert foncé
}
