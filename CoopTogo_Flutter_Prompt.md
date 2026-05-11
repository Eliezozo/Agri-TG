# Agri-TG — Prompt de conception Flutter (Phase 3 Finale)
> MIABE Hackathon 2026 · Darollo Technologies Corporation  
> Document de référence pour le développement étape par étape

---

## Table des matières

1. [Contexte & objectifs](#1-contexte--objectifs)
2. [Stack technique](#2-stack-technique)
3. [Architecture des dossiers](#3-architecture-des-dossiers)
4. [Modèles de données](#4-modèles-de-données)
5. [Configuration initiale](#5-configuration-initiale)
6. [Étape 1 — Thème & Design System](#étape-1--thème--design-system)
7. [Étape 2 — Navigation (Go Router)](#étape-2--navigation-go-router)
8. [Étape 3 — Authentification](#étape-3--authentification)
9. [Étape 4 — Tableau de bord](#étape-4--tableau-de-bord)
10. [Étape 5 — Transactions](#étape-5--transactions)
11. [Étape 6 — Votes](#étape-6--votes)
12. [Étape 7 — Rapports mensuels](#étape-7--rapports-mensuels)
13. [Étape 8 — Profil & Paramètres](#étape-8--profil--paramètres)
14. [Étape 9 — Intégration Blockchain](#étape-9--intégration-blockchain)
15. [Étape 10 — Notifications (FCM)](#étape-10--notifications-fcm)
16. [Étape 11 — Mode offline & cache](#étape-11--mode-offline--cache)
17. [Étape 12 — Tests & finalisation](#étape-12--tests--finalisation)
18. [API Reference](#api-reference)
19. [Checklist livrable finale](#checklist-livrable-finale)

---

## 1. Contexte & objectifs

### Problème résolu
Les coopératives agricoles togolaises gèrent des fonds collectifs (cotisations, primes, achats groupés) avec une comptabilité 100 % manuelle et opaque. Les membres n'ont aucun accès aux comptes. Les détournements sont documentés.

### Solution
Une application mobile Flutter connectée à un registre blockchain immuable, permettant à chaque membre de :
- Consulter en temps réel le solde et l'historique de sa coopérative
- Participer aux votes sur les décisions financières importantes
- Télécharger un rapport mensuel certifié blockchain

### Périmètre Phase 3 (Finale)
- MVP complet : tableau de bord web (déjà livré Phase 2) + **application mobile** (ce livrable)
- Rapport mensuel auto-généré depuis les données blockchain
- Gestion des rôles : `président`, `trésorier`, `membre` avec permissions distinctes
- Pitch 10 min avec démonstration live d'un cycle complet de gouvernance

---

## 2. Stack technique

### Dépendances principales (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Réseau
  dio: ^5.4.3
  retrofit: ^4.1.0
  pretty_dio_logger: ^1.3.1

  # Blockchain
  web3dart: ^2.7.3

  # Cache local & offline
  hive_flutter: ^1.1.0
  hive: ^2.2.3

  # Sécurité
  flutter_secure_storage: ^9.0.0

  # UI
  fl_chart: ^0.67.0
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  lottie: ^3.1.0

  # PDF
  pdf: ^3.10.8
  printing: ^5.12.0
  path_provider: ^2.1.3

  # Notifications
  firebase_core: ^2.30.1
  firebase_messaging: ^14.9.4
  flutter_local_notifications: ^17.1.2

  # Utilitaires
  intl: ^0.19.0
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  retrofit_generator: ^8.1.0
  riverpod_generator: ^2.4.0
  hive_generator: ^2.0.1
```

### Justification des choix

| Outil | Raison |
|-------|--------|
| Riverpod 2 | Plus simple que BLoC pour un hackathon, typage fort, pas de contexte requis |
| Go Router | Navigation déclarative, gestion des guards d'auth, deep links |
| Dio + Retrofit | Client HTTP typé avec génération de code, intercepteurs JWT faciles |
| Web3Dart | Seul package Flutter mature pour interactions EVM |
| Hive | Base locale ultra-rapide, parfaite pour cache offline sur Android bas de gamme |
| fl_chart | Graphiques légers, performants, très customisables |

### Réseau blockchain recommandé
- **Celo** ou **Polygon (MATIC)** : frais quasi nuls, adapté à l'Afrique, compatibles EVM
- Pour la démo hackathon : **Hardhat local** (mock réseau) suffit

---

## 3. Architecture des dossiers

```
lib/
├── main.dart
├── app.dart                    # MaterialApp + ProviderScope
├── core/
│   ├── theme/
│   │   ├── app_theme.dart      # ThemeData light/dark
│   │   ├── app_colors.dart     # Palette constantes
│   │   └── app_text_styles.dart
│   ├── router/
│   │   ├── app_router.dart     # GoRouter config + guards
│   │   └── app_routes.dart     # Constantes des routes
│   ├── api/
│   │   ├── api_client.dart     # Dio singleton + interceptors
│   │   ├── api_endpoints.dart  # URLs constantes
│   │   └── auth_interceptor.dart
│   ├── blockchain/
│   │   ├── blockchain_client.dart
│   │   ├── contracts/
│   │   │   ├── vote_contract.dart
│   │   │   └── abis/           # JSON ABI des smart contracts
│   │   └── blockchain_tx_model.dart
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── error_handler.dart
│   └── utils/
│       ├── formatters.dart     # Montants FCFA, dates fr
│       └── validators.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_api_service.dart
│   │   ├── domain/
│   │   │   └── auth_models.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── pin_setup_screen.dart
│   │       └── coop_selection_screen.dart
│   ├── dashboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── dashboard_screen.dart
│   │       └── widgets/
│   │           ├── balance_card.dart
│   │           ├── stat_grid.dart
│   │           └── recent_transactions_list.dart
│   ├── transactions/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── transactions_screen.dart
│   │       ├── transaction_detail_screen.dart
│   │       └── widgets/
│   │           ├── transaction_tile.dart
│   │           └── filter_sheet.dart
│   ├── votes/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── votes_screen.dart
│   │       ├── vote_detail_screen.dart
│   │       └── widgets/
│   │           ├── vote_card.dart
│   │           └── vote_progress_bar.dart
│   ├── reports/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── reports_screen.dart
│   │       └── widgets/
│   │           ├── expense_pie_chart.dart
│   │           └── report_summary_card.dart
│   └── profile/
│       └── presentation/
│           └── profile_screen.dart
└── shared/
    ├── widgets/
    │   ├── app_scaffold.dart       # Scaffold commun + bottom nav
    │   ├── blockchain_badge.dart   # Badge "Validé blockchain"
    │   ├── loading_overlay.dart
    │   ├── error_widget.dart
    │   └── offline_banner.dart
    └── providers/
        └── connectivity_provider.dart
```

---

## 4. Modèles de données

### Transaction

```dart
// lib/features/transactions/domain/transaction_model.dart

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String type,          // 'cotisation' | 'achat' | 'prime' | 'autre'
    required double amount,        // positif = entrée, négatif = sortie
    required String blockchainHash,
    required DateTime date,
    required String description,
    String? memberName,
    String? category,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
```

### Vote

```dart
// lib/features/votes/domain/vote_model.dart

@freezed
class Vote with _$Vote {
  const factory Vote({
    required String id,
    required String title,
    required String description,
    required double amountThreshold,
    required int forCount,
    required int againstCount,
    required int abstainCount,
    required int totalMembers,
    required DateTime closingDate,
    required String status,         // 'open' | 'closed' | 'pending'
    String? currentMemberVote,      // null si pas encore voté
    String? blockchainHash,
  }) = _Vote;

  factory Vote.fromJson(Map<String, dynamic> json) =>
      _$VoteFromJson(json);
}
```

### Membre

```dart
// lib/features/auth/domain/auth_models.dart

@freezed
class CoopMember with _$CoopMember {
  const factory CoopMember({
    required String id,
    required String fullName,
    required String phone,
    required String role,           // 'membre' | 'tresorier' | 'president'
    required String cooperativeId,
    required String cooperativeName,
    DateTime? joinedAt,
  }) = _CoopMember;

  factory CoopMember.fromJson(Map<String, dynamic> json) =>
      _$CoopMemberFromJson(json);
}
```

### Rapport mensuel

```dart
// lib/features/reports/domain/report_model.dart

@freezed
class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required String id,
    required String month,          // ex: "2026-04"
    required double totalIn,
    required double totalOut,
    required double balance,
    required int transactionCount,
    required Map<String, double> byCategory,
    required String blockchainHash,
    required DateTime generatedAt,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);
}
```

---

## 5. Configuration initiale

### Étapes de setup (dans l'ordre)

```bash
# 1. Créer le projet
flutter create coop_togo_app --org com.dtc.coop --platforms android,ios

# 2. Ajouter les dépendances (copier pubspec.yaml ci-dessus)
flutter pub get

# 3. Générer le code (freezed, json_serializable, riverpod, hive)
dart run build_runner build --delete-conflicting-outputs

# 4. Configurer Firebase (pour FCM)
# Installer FlutterFire CLI puis :
flutterfire configure
```

### Variables d'environnement (`lib/core/config/app_config.dart`)

```dart
class AppConfig {
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000/api');
  static const String rpcUrl =
      String.fromEnvironment('RPC_URL', defaultValue: 'http://10.0.2.2:8545');
  static const String voteContractAddress =
      String.fromEnvironment('VOTE_CONTRACT', defaultValue: '0x...');
}
```

> **Note :** `10.0.2.2` est l'adresse du localhost sur émulateur Android. Remplacer par l'IP réelle sur appareil physique.

---

## Étape 1 — Thème & Design System

> **Pourquoi en premier ?** Définir les couleurs et styles avant tout évite de refactoriser l'UI plus tard.

### Palette (`lib/core/theme/app_colors.dart`)

```dart
abstract class AppColors {
  // Primaires
  static const Color primary      = Color(0xFF1D9E75);
  static const Color primaryDark  = Color(0xFF0F6E56);
  static const Color primaryLight = Color(0xFF5DCAA5);

  // Fonds (thème sombre prioritaire)
  static const Color bgDark       = Color(0xFF0D1F18);
  static const Color bgCard       = Color(0xFF0D2A1F);
  static const Color bgAccent     = Color(0xFF0D3D2B);

  // Texte
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9FE1CB);
  static const Color textMuted     = Color(0xFF666666);

  // Sémantique
  static const Color success = Color(0xFF1D9E75);
  static const Color danger  = Color(0xFFF0997B);
  static const Color warning = Color(0xFFFAC775);
  static const Color info    = Color(0xFF5DCAA5);
}
```

### Thème (`lib/core/theme/app_theme.dart`)

```dart
ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    surface: AppColors.bgCard,
    background: AppColors.bgDark,
  ),
  scaffoldBackgroundColor: AppColors.bgDark,
  cardColor: AppColors.bgCard,
  // Définir TextTheme, AppBarTheme, BottomNavigationBarTheme ici
);
```

### ✅ Critères de validation Étape 1
- [ ] `flutter run` affiche un écran vert foncé sans erreur
- [ ] Aucune couleur hardcodée en dehors de `AppColors`
- [ ] Le thème sombre est appliqué globalement dans `app.dart`

---

## Étape 2 — Navigation (Go Router)

> **Pourquoi avant les écrans ?** Définir toutes les routes évite les imports circulaires et les refactorisations de navigation.

### Routes (`lib/core/router/app_routes.dart`)

```dart
abstract class AppRoutes {
  static const String splash       = '/';
  static const String login        = '/login';
  static const String pinSetup     = '/pin-setup';
  static const String coopSelect   = '/coop-selection';
  static const String dashboard    = '/dashboard';
  static const String transactions = '/transactions';
  static const String txDetail     = '/transactions/:id';
  static const String votes        = '/votes';
  static const String voteDetail   = '/votes/:id';
  static const String reports      = '/reports';
  static const String profile      = '/profile';
}
```

### Router avec garde d'authentification

```dart
// lib/core/router/app_router.dart

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation == '/';

      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      // ... autres routes
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard, builder: (_, __) => const DashboardScreen()),
          GoRoute(path: AppRoutes.transactions, builder: (_, __) => const TransactionsScreen()),
          GoRoute(path: AppRoutes.votes, builder: (_, __) => const VotesScreen()),
          GoRoute(path: AppRoutes.reports, builder: (_, __) => const ReportsScreen()),
        ],
      ),
    ],
  );
});
```

### ✅ Critères de validation Étape 2
- [ ] La navigation fonctionne entre tous les écrans principaux
- [ ] Un utilisateur non connecté est redirigé vers `/login`
- [ ] Un utilisateur connecté ne peut pas accéder à `/login`
- [ ] Le `ShellRoute` affiche correctement la bottom navigation bar

---

## Étape 3 — Authentification

> **Construire dans cet ordre :** Repository → Provider → UI

### 3.1 Service API (`auth_api_service.dart`)

```dart
@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @GET('/auth/me')
  Future<CoopMember> getProfile();
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    required String pin,
  }) = _LoginRequest;
  factory LoginRequest.fromJson(Map<String, dynamic> j) => _$LoginRequestFromJson(j);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required CoopMember member,
  }) = _AuthResponse;
  factory AuthResponse.fromJson(Map<String, dynamic> j) => _$AuthResponseFromJson(j);
}
```

### 3.2 Repository

```dart
// lib/features/auth/data/auth_repository.dart

class AuthRepository {
  final AuthApiService _api;
  final FlutterSecureStorage _storage;

  Future<CoopMember> login(String phone, String pin) async {
    try {
      final response = await _api.login(LoginRequest(phone: phone, pin: pin));
      await _storage.write(key: 'jwt_token', value: response.token);
      return response.member;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<String?> getStoredToken() async {
    return _storage.read(key: 'jwt_token');
  }
}
```

### 3.3 Provider Riverpod

```dart
// lib/features/auth/data/auth_provider.dart

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<CoopMember?> build() async {
    final token = await ref.read(authRepositoryProvider).getStoredToken();
    if (token == null) return null;
    return ref.read(authRepositoryProvider).getProfile();
  }

  Future<void> login(String phone, String pin) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(phone, pin),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
```

### 3.4 Écrans UI

**`LoginScreen`** — Structure :
```
Column(
  ├── Logo + nom de l'app
  ├── TextField : numéro de téléphone (keyboardType: phone)
  ├── TextField : PIN (obscureText: true, maxLength: 6)
  ├── ElevatedButton : "Se connecter"
  │     onPressed → authNotifier.login(phone, pin)
  └── Gestion état : loading → CircularProgressIndicator
                     error → SnackBar rouge avec message
)
```

**`CoopSelectionScreen`** — Si un membre appartient à plusieurs coopératives :
```
ListView.builder sur la liste des coopératives
  └── ListTile avec nom + nombre de membres → onTap → sélectionne et navigue
```

### ✅ Critères de validation Étape 3
- [ ] Connexion avec des credentials valides navigue vers `/dashboard`
- [ ] Mauvais PIN affiche un message d'erreur clair en français
- [ ] Le token est persisté : fermer et rouvrir l'app garde la session
- [ ] Logout efface le token et redirige vers `/login`

---

## Étape 4 — Tableau de bord

> **Construire dans cet ordre :** Provider de données → Widgets atomiques → Screen

### 4.1 Provider

```dart
@riverpod
Future<DashboardData> dashboardData(DashboardDataRef ref) async {
  final coopId = ref.watch(currentCoopIdProvider);
  final api = ref.watch(coopApiServiceProvider);

  // Polling automatique toutes les 30 secondes
  ref.keepAlive();
  Timer.periodic(const Duration(seconds: 30), (_) => ref.invalidateSelf());

  final balance = await api.getBalance(coopId);
  final recentTx = await api.getTransactions(coopId, limit: 5);
  final stats = await api.getStats(coopId);

  return DashboardData(balance: balance, recentTransactions: recentTx, stats: stats);
}
```

### 4.2 Widgets à créer

**`BalanceCard`**
```dart
// Carte verte avec :
// - Label "Solde collectif" en petit
// - Montant formaté en FCFA en grand (ex: "1 248 500 FCFA")
// - Sous-titre "Mis à jour il y a X min · Blockchain"
// - Badge blockchain en bas à droite
```

**`StatGrid`**
```dart
// GridView 2x2 avec 4 MetricCard :
// - Membres actifs
// - Votes ouverts
// - Entrées du mois (vert)
// - Sorties du mois (rouge)
```

**`RecentTransactionsList`**
```dart
// ListView des 5 dernières transactions
// Chaque item : icône colorée + description + date + montant
// onTap → navigate to /transactions/:id
```

**`BlockchainBadge`** (widget partagé)
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  decoration: BoxDecoration(
    color: AppColors.bgAccent,
    borderRadius: BorderRadius.circular(4),
  ),
  child: Row(children: [
    Icon(Icons.verified, size: 10, color: AppColors.primaryLight),
    SizedBox(width: 4),
    Text('Validé blockchain', style: /* 9px vert */),
  ]),
)
```

### 4.3 Gestion des états dans le Screen

```dart
// Pattern à appliquer sur TOUS les écrans avec données async :

ref.watch(dashboardDataProvider).when(
  loading: () => const DashboardSkeleton(),  // shimmer
  error: (e, _) => ErrorWidget(message: e.toString(), onRetry: () => ref.invalidate(dashboardDataProvider)),
  data: (data) => DashboardContent(data: data),
);
```

### ✅ Critères de validation Étape 4
- [ ] Le solde s'affiche correctement formaté en FCFA
- [ ] Le polling toutes les 30s met à jour les données sans rechargement manuel
- [ ] En cas d'erreur réseau, un widget d'erreur avec bouton "Réessayer" s'affiche
- [ ] L'état de chargement affiche des skeleton loaders (shimmer), pas un spinner vide

---

## Étape 5 — Transactions

### 5.1 Liste paginée

```dart
// Utiliser infinite_scroll_pagination avec Riverpod

@riverpod
class TransactionsPagination extends _$TransactionsPagination {
  static const _pageSize = 20;

  @override
  build() => PagingController<int, Transaction>(firstPageKey: 1)
    ..addPageRequestListener(_fetchPage);

  Future<void> _fetchPage(int page) async {
    final api = ref.read(coopApiServiceProvider);
    final coopId = ref.read(currentCoopIdProvider);
    final filter = ref.read(transactionFilterProvider);

    try {
      final results = await api.getTransactions(
        coopId, page: page, limit: _pageSize,
        type: filter.type, startDate: filter.startDate,
      );
      final isLast = results.length < _pageSize;
      isLast
        ? state.appendLastPage(results)
        : state.appendPage(results, page + 1);
    } catch (e) {
      state.error = e;
    }
  }
}
```

### 5.2 `TransactionTile`

```dart
ListTile(
  leading: CircleAvatar(
    backgroundColor: transaction.amount > 0
        ? AppColors.bgAccent
        : Color(0xFF3D1A0D),
    child: Icon(
      transaction.amount > 0 ? Icons.arrow_upward : Icons.arrow_downward,
      color: transaction.amount > 0 ? AppColors.primary : AppColors.danger,
      size: 16,
    ),
  ),
  title: Text(transaction.description),
  subtitle: Text(
    '${formatDate(transaction.date)} · ${transaction.blockchainHash.substring(0, 8)}...',
    style: /* muted 11px */
  ),
  trailing: Text(
    formatAmount(transaction.amount),
    style: TextStyle(
      color: transaction.amount > 0 ? AppColors.primary : AppColors.danger,
      fontWeight: FontWeight.w600,
    ),
  ),
  onTap: () => context.go('/transactions/${transaction.id}'),
)
```

### 5.3 `TransactionDetailScreen`

Afficher :
- Montant en grand
- Type & catégorie
- Date et heure exactes
- Nom du membre concerné (si trésorier)
- Hash blockchain complet avec bouton copier
- Lien vers explorateur blockchain (`url_launcher`)
- Badge "Immuable · validé le [date]"

### 5.4 Feuille de filtres (`FilterSheet`)

`showModalBottomSheet` contenant :
- Sélecteur de type : Tous / Cotisation / Achat / Prime
- Date de début et date de fin (DatePicker)
- Bouton "Appliquer les filtres"

### ✅ Critères de validation Étape 5
- [ ] Le scroll infini charge la page suivante automatiquement
- [ ] Les filtres modifient la liste sans recharger toute la page
- [ ] Le hash blockchain complet est copiable avec feedback (SnackBar "Copié !")
- [ ] La liste est vide avec un message explicatif si aucun résultat

---

## Étape 6 — Votes

### 6.1 `VoteCard`

```dart
Card(
  child: Column(children: [
    // En-tête : statut badge + date de clôture
    Row(children: [
      StatusBadge(status: vote.status),
      Spacer(),
      Text('Clôt le ${formatDate(vote.closingDate)}'),
    ]),
    // Titre du vote
    Text(vote.title, style: /* 14px bold */),
    // Description courte
    Text(vote.description, maxLines: 2),
    // Barre de progression Pour/Contre
    VoteProgressBar(vote: vote),
    // Boutons si vote ouvert et pas encore voté
    if (vote.status == 'open' && vote.currentMemberVote == null)
      VoteActionButtons(voteId: vote.id),
    // Résultat si déjà voté
    if (vote.currentMemberVote != null)
      VotedIndicator(choice: vote.currentMemberVote!),
  ]),
)
```

### 6.2 `VoteProgressBar`

```dart
// Calculer les pourcentages
final total = vote.forCount + vote.againstCount + vote.abstainCount;
final forPct = total > 0 ? vote.forCount / total : 0.0;

Column(children: [
  Row(children: [
    Text('Pour (${(forPct * 100).round()}%)'),
    Spacer(),
    Text('Contre (${((1-forPct) * 100).round()}%)'),
  ]),
  ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: LinearProgressIndicator(
      value: forPct,
      color: AppColors.primary,
      backgroundColor: AppColors.danger.withOpacity(0.3),
      minHeight: 8,
    ),
  ),
  Text('${vote.forCount + vote.againstCount} / ${vote.totalMembers} membres ont voté'),
])
```

### 6.3 Action de vote

```dart
// IMPORTANT : Confirmer avant d'envoyer sur la blockchain

Future<void> castVote(String voteId, String choice) async {
  // 1. Afficher dialog de confirmation
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => ConfirmVoteDialog(choice: choice),
  );
  if (confirmed != true) return;

  // 2. Afficher loader
  ref.read(loadingProvider.notifier).show();

  try {
    // 3. Appel API → enregistrement blockchain côté backend
    await ref.read(votesRepositoryProvider).castVote(voteId, choice);

    // 4. Invalider le provider pour rafraîchir
    ref.invalidate(votesProvider);
    ref.invalidate(dashboardDataProvider);

    // 5. Feedback succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote enregistré sur la blockchain ✓'), backgroundColor: AppColors.primary),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : ${e.toString()}'), backgroundColor: AppColors.danger),
    );
  } finally {
    ref.read(loadingProvider.notifier).hide();
  }
}
```

### ✅ Critères de validation Étape 6
- [ ] Un membre ne peut voter qu'une seule fois (boutons grisés après vote)
- [ ] Un vote clos n'affiche que les résultats, pas les boutons
- [ ] La barre de progression se met à jour en temps réel après un vote
- [ ] La dialog de confirmation affiche clairement le choix avant envoi blockchain

---

## Étape 7 — Rapports mensuels

### 7.1 Sélecteur de mois

```dart
// Dropdown ou horizontal scroll de pills pour choisir le mois
// Déclenche ref.read(selectedMonthProvider.notifier).state = newMonth
// Ce qui invalide automatiquement le provider du rapport
```

### 7.2 `ExpensePieChart`

```dart
// Utiliser fl_chart PieChart
PieChart(
  PieChartData(
    sections: report.byCategory.entries.map((e) => PieChartSectionData(
      value: e.value,
      title: '${(e.value / report.totalOut * 100).round()}%',
      color: getCategoryColor(e.key),
      radius: 50,
    )).toList(),
  ),
)
```

### 7.3 Export PDF

```dart
Future<void> exportPdf(MonthlyReport report) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
    build: (context) => pw.Column(children: [
      pw.Text('Rapport mensuel — ${report.month}', style: pw.TextStyle(fontSize: 20)),
      pw.Text('Coopérative : ${cooperativeName}'),
      pw.Divider(),
      pw.Row(children: [
        pw.Text('Total entrées :'),
        pw.Text(formatAmount(report.totalIn), style: /* vert */),
      ]),
      pw.Row(children: [
        pw.Text('Total sorties :'),
        pw.Text(formatAmount(report.totalOut), style: /* rouge */),
      ]),
      pw.Row(children: [
        pw.Text('Bilan :'),
        pw.Text(formatAmount(report.balance)),
      ]),
      pw.Divider(),
      pw.Text('Certifié blockchain : ${report.blockchainHash}'),
      pw.Text('Généré le : ${formatDateTime(report.generatedAt)}'),
    ]),
  ));

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'rapport_${report.month}.pdf',
  );
}
```

### ✅ Critères de validation Étape 7
- [ ] Changer de mois charge le bon rapport
- [ ] Le graphique camembert affiche les bonnes proportions
- [ ] Le PDF est correctement généré et partageable
- [ ] Le hash blockchain est visible sur le PDF (preuve d'authenticité)

---

## Étape 8 — Profil & Paramètres

### Informations à afficher
- Avatar avec initiales
- Nom complet et numéro de téléphone
- Rôle dans la coopérative (avec icône différente par rôle)
- Date d'adhésion
- Nom de la coopérative

### Paramètres
- Toggle : notification pour nouveaux votes
- Slider : seuil de montant pour notification transaction (ex: > 50 000 FCFA)
- Bouton : changer le PIN
- Bouton : se déconnecter (avec confirmation)

### Permissions par rôle

| Fonctionnalité | Membre | Trésorier | Président |
|----------------|--------|-----------|-----------|
| Voir solde | ✅ | ✅ | ✅ |
| Voir transactions | ✅ | ✅ | ✅ |
| Filtrer par membre | ❌ | ✅ | ✅ |
| Voter | ✅ | ✅ | ✅ |
| Créer un vote | ❌ | ❌ | ✅ |
| Voir rapports | ✅ | ✅ | ✅ |
| Exporter rapport | ❌ | ✅ | ✅ |

```dart
// Vérification de rôle dans les widgets :
if (ref.watch(currentMemberProvider).role == 'president')
  ElevatedButton(onPressed: () => context.go('/votes/create'), child: Text('Créer un vote')),
```

### ✅ Critères de validation Étape 8
- [ ] Les boutons hors rôle sont cachés (pas seulement désactivés)
- [ ] Le changement de PIN demande l'ancien PIN avant
- [ ] La déconnexion demande une confirmation

---

## Étape 9 — Intégration Blockchain

> Cette étape peut utiliser un **mock** pendant la démo si le backend signe les transactions.

### Option A — Backend signing (recommandé pour hackathon)
Le backend Flutter envoie simplement des appels REST. C'est le serveur Node.js/Python qui signe et soumet les transactions à la blockchain. L'app affiche les hashs retournés.

```dart
// Pas besoin de web3dart côté app dans ce cas.
// Afficher simplement les hashs retournés par l'API.
```

### Option B — Client signing avec web3dart

```dart
// lib/core/blockchain/blockchain_client.dart

class BlockchainClient {
  final Web3Client _client;
  final DeployedContract _voteContract;

  Future<String> castVoteOnChain({
    required String voteId,
    required int choice,       // 0=pour, 1=contre, 2=abstention
    required Credentials credentials,
  }) async {
    final function = _voteContract.function('castVote');
    final txHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: _voteContract,
        function: function,
        parameters: [BigInt.parse(voteId), BigInt.from(choice)],
      ),
    );
    return txHash;
  }
}
```

### Affichage du hash
- Tronquer à `0x${hash.substring(2, 8)}...${hash.substring(hash.length - 4)}`
- Lien complet vers `https://explorer.celo.org/tx/${hash}` (ou Polygon)
- Copier dans le presse-papier avec `Clipboard.setData`

### ✅ Critères de validation Étape 9
- [ ] Chaque transaction affiche un hash blockchain valide
- [ ] Le lien vers l'explorateur ouvre bien la transaction
- [ ] Pour la démo : au moins 1 vote et 1 transaction sont visibles sur l'explorateur

---

## Étape 10 — Notifications (FCM)

### Setup

```dart
// main.dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
```

### Types de notifications à implémenter

| Événement | Destinataires | Message |
|-----------|--------------|---------|
| Nouveau vote ouvert | Tous les membres | "Nouveau vote : [titre]" |
| Vote clôturé | Tous les membres | "Résultat vote : [Pour X% / Contre Y%]" |
| Transaction > seuil | Tous les membres | "Transaction de [montant] enregistrée" |
| Rapport mensuel prêt | Tous les membres | "Le rapport d'[avril] est disponible" |

### Handler

```dart
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Afficher notification locale
  await FlutterLocalNotificationsPlugin().show(
    0,
    message.notification?.title,
    message.notification?.body,
    const NotificationDetails(/* ... */),
  );
}
```

### ✅ Critères de validation Étape 10
- [ ] Une notification arrive quand un vote est créé (test manuel)
- [ ] Tapper la notification ouvre le bon écran (deep link via Go Router)

---

## Étape 11 — Mode offline & cache

### Cache avec Hive

```dart
// lib/core/cache/transaction_cache.dart

@HiveType(typeId: 0)
class CachedTransaction extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String json; // Transaction sérialisée
  @HiveField(2) late DateTime cachedAt;
}

// Dans le repository :
Future<List<Transaction>> getTransactions(...) async {
  try {
    final fresh = await _api.getTransactions(...);
    await _cacheTransactions(fresh);
    return fresh;
  } catch (e) {
    // Retourner le cache si réseau indisponible
    return _getCachedTransactions();
  }
}
```

### Bannière offline

```dart
// lib/shared/widgets/offline_banner.dart
// Afficher un bandeau orange en haut de l'app si pas de réseau

Consumer(builder: (context, ref, _) {
  final isOnline = ref.watch(connectivityProvider);
  return AnimatedContainer(
    height: isOnline ? 0 : 32,
    color: AppColors.warning,
    child: Center(child: Text('Mode hors ligne — données mises en cache')),
  );
})
```

### ✅ Critères de validation Étape 11
- [ ] En coupant le WiFi, l'app affiche le bandeau orange
- [ ] Les transactions du cache sont visibles hors ligne
- [ ] La reconnexion déclenche un rafraîchissement automatique

---

## Étape 12 — Tests & finalisation

### Tests à écrire

```dart
// Test unitaire : formatage des montants
test('formatAmount affiche correctement le FCFA', () {
  expect(formatAmount(1248500), '1 248 500 FCFA');
  expect(formatAmount(-82000), '- 82 000 FCFA');
});

// Test widget : BalanceCard
testWidgets('BalanceCard affiche le solde', (tester) async {
  await tester.pumpWidget(MaterialApp(home: BalanceCard(balance: 1248500)));
  expect(find.text('1 248 500 FCFA'), findsOneWidget);
});

// Test intégration : login → dashboard
testWidgets('Login réussi navigue vers dashboard', (tester) async {
  // Mock du repository d'auth
  // ...
});
```

### Checklist performance (Android bas de gamme)

- [ ] Pas d'animations > 300ms sur des listes
- [ ] Les images ont toutes un `cacheWidth` / `cacheHeight` défini
- [ ] `const` sur tous les widgets statiques
- [ ] `ListView.builder` utilisé pour toutes les listes (jamais `ListView` avec `children`)
- [ ] Pas de `rebuild` inutile (utiliser `select` sur les providers Riverpod)

### Build de production

```bash
# Android APK signé
flutter build apk --release --dart-define=API_BASE_URL=https://votre-api.com

# Android App Bundle (si Play Store)
flutter build appbundle --release
```

---

## API Reference

### Authentification
```
POST /auth/login
Body: { "phone": "string", "pin": "string" }
Response: { "token": "JWT", "member": CoopMember }

GET /auth/me
Headers: Authorization: Bearer {token}
Response: CoopMember
```

### Coopérative
```
GET /api/coop/{id}/balance
Response: { "balance": number, "updatedAt": ISO8601 }

GET /api/coop/{id}/stats
Response: { "activeMembers": number, "openVotes": number, "monthlyIn": number, "monthlyOut": number }
```

### Transactions
```
GET /api/coop/{id}/transactions?page=1&limit=20&type=&startDate=&endDate=
Response: Transaction[]

GET /api/coop/{id}/transactions/{txId}
Response: Transaction (avec blockchainHash complet)
```

### Votes
```
GET /api/coop/{id}/votes?status=open
Response: Vote[]

GET /api/coop/{id}/votes/{voteId}
Response: Vote (avec détails complets)

POST /api/coop/{id}/votes/{voteId}/cast
Body: { "choice": "for" | "against" | "abstain" }
Response: { "txHash": "0x...", "success": true }
```

### Rapports
```
GET /api/coop/{id}/reports/{month}    (format: YYYY-MM)
Response: MonthlyReport
```

---

## Checklist livrable finale

### Code
- [ ] Architecture en features respectée
- [ ] Zéro `print()` en production (utiliser `debugPrint` ou un logger)
- [ ] Toutes les erreurs réseau sont catchées et affichées en français
- [ ] Aucune clé API ou URL hardcodée (tout dans `AppConfig`)
- [ ] `dart run build_runner build` passe sans erreur
- [ ] `flutter analyze` passe sans warning

### UX
- [ ] Toutes les actions longues ont un loader
- [ ] Les messages d'erreur sont en français, compréhensibles par un agriculteur
- [ ] Le mode offline est fonctionnel (test avec avion mode)
- [ ] L'app fonctionne sur Android 8+ avec 2 Go de RAM

### Démo hackathon (10 min)
- [ ] Connexion membre (30s)
- [ ] Consultation du solde et des transactions (1 min)
- [ ] Participation à un vote → hash blockchain visible (2 min)
- [ ] Rapport mensuel → export PDF (1 min)
- [ ] Démonstration d'une transaction enregistrée visible par tous en temps réel (2 min)
- [ ] Présentation des rôles différenciés (1 min)
- [ ] Q&A (3 min)

### Fichiers à remettre
- [ ] Code source Flutter complet sur GitHub/GitLab
- [ ] APK signé installable (`app-release.apk`)
- [ ] `README.md` avec instructions d'installation
- [ ] Adresse du smart contract déployé
- [ ] URL de l'API backend (ou instructions pour lancer en local)

---

*Document généré pour le MIABE Hackathon 2026 — Darollo Technologies Corporation*  
*Phase 3 · Application mobile Flutter · Gouvernance coopérative blockchain*
