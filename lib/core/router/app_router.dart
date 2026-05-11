import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/coop_selection_screen.dart';
import '../../features/auth/data/auth_provider.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import '../../features/transactions/presentation/transaction_detail_screen.dart';
import '../../features/votes/presentation/votes_screen.dart';
import '../../features/votes/presentation/vote_detail_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/reports/presentation/report_detail_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      if (authState.isLoading) return AppRoutes.splash;
      
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation == '/';

      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) {
         if (state.matchedLocation == '/login' || state.matchedLocation == '/') {
            return AppRoutes.coopSelect;
         }
      }
      
      if (state.matchedLocation == '/' && !authState.isLoading && !isLoggedIn) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.coopSelect, builder: (_, __) => const CoopSelectionScreen()),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard, builder: (_, __) => const DashboardScreen()),
          GoRoute(path: AppRoutes.transactions, builder: (_, __) => const TransactionsScreen()),
          GoRoute(path: '${AppRoutes.transactions}/:id', builder: (_, state) => TransactionDetailScreen(id: state.pathParameters['id']!)),
          GoRoute(path: AppRoutes.votes, builder: (_, __) => const VotesScreen()),
          GoRoute(path: '${AppRoutes.votes}/:id', builder: (_, state) => VoteDetailScreen(id: state.pathParameters['id']!)),
          GoRoute(path: AppRoutes.reports, builder: (_, __) => const ReportsScreen()),
          GoRoute(path: '${AppRoutes.reports}/:id', builder: (_, state) => ReportDetailScreen(id: state.pathParameters['id']!)),
          GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
});
