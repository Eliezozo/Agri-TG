import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/member_dashboard_screen.dart';
import '../../features/dashboard/presentation/treasurer_dashboard_screen.dart';
import '../../features/dashboard/presentation/president_dashboard_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import '../../features/transactions/presentation/transaction_detail_screen.dart';
import '../../features/votes/presentation/votes_screen.dart';
import '../../features/votes/presentation/vote_detail_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/reports/presentation/report_detail_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/blockchain/presentation/block_simulator_screen.dart';
import '../../shared/widgets/app_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/blockchain-demo', builder: (_, __) => const BlockSimulatorScreen()),

      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(path: '/dashboard/membre', builder: (_, __) => const MemberDashboardScreen()),
          GoRoute(path: '/dashboard/tresorier', builder: (_, __) => const TreasurerDashboardScreen()),
          GoRoute(path: '/dashboard/president', builder: (_, __) => const PresidentDashboardScreen()),
          GoRoute(path: '/transactions', builder: (_, __) => const TransactionsScreen()),
          GoRoute(path: '/transactions/:id', builder: (_, state) => TransactionDetailScreen(id: state.pathParameters['id']!)),
          GoRoute(path: '/votes', builder: (_, __) => const VotesScreen()),
          GoRoute(path: '/votes/:id', builder: (_, state) => VoteDetailScreen(id: state.pathParameters['id']!)),
          GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
          GoRoute(path: '/reports/:id', builder: (_, state) => ReportDetailScreen(id: state.pathParameters['id']!)),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
});
