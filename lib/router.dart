import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'features/cards/card_detail_screen.dart';
import 'features/cards/cards_screen.dart';
import 'features/cards/installments_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/home_shell.dart';
import 'features/import/csv_import_screen.dart';
import 'features/import/paste_import_screen.dart';
import 'features/import/sms_history_screen.dart';
import 'features/more_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/review/review_screen.dart';
import 'features/settings/audit_screen.dart';
import 'features/settings/backup_screen.dart';
import 'features/settings/categories_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/sources/ios_shortcut_guide.dart';
import 'features/sources/sources_screen.dart';
import 'features/transactions/transaction_edit_screen.dart';
import 'features/transactions/transactions_screen.dart';

class _SettingsListenable extends ChangeNotifier {
  _SettingsListenable(WidgetRef ref) {
    ref.listenManual(settingsProvider.select((s) => s.onboarded), (_, _) => notifyListeners());
  }
}

GoRouter buildRouter(WidgetRef ref) {
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/dashboard',
    refreshListenable: _SettingsListenable(ref),
    redirect: (context, state) {
      final onboarded = ref.read(settingsProvider).onboarded;
      final atOnboarding = state.matchedLocation == '/onboarding';
      if (!onboarded && !atOnboarding) return '/onboarding';
      if (onboarded && atOnboarding) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/dashboard', builder: (_, _) => const DashboardScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/transactions', builder: (_, _) => const TransactionsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/review', builder: (_, _) => const ReviewScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/more', builder: (_, _) => const MoreScreen())],
          ),
        ],
      ),
      GoRoute(parentNavigatorKey: rootKey, path: '/txn/new', builder: (_, _) => const TransactionEditScreen()),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/txn/:id',
        builder: (_, s) => TransactionEditScreen(id: int.parse(s.pathParameters['id']!)),
      ),
      GoRoute(parentNavigatorKey: rootKey, path: '/cards', builder: (_, _) => const CardsScreen()),
      GoRoute(
        parentNavigatorKey: rootKey,
        path: '/cards/:id',
        builder: (_, s) => CardDetailScreen(id: int.parse(s.pathParameters['id']!)),
      ),
      GoRoute(parentNavigatorKey: rootKey, path: '/installments', builder: (_, _) => const InstallmentsScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/sources', builder: (_, _) => const SourcesScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/sources/ios-guide', builder: (_, _) => const IosShortcutGuide()),
      GoRoute(parentNavigatorKey: rootKey, path: '/import/paste', builder: (_, _) => const PasteImportScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/import/sms', builder: (_, _) => const SmsHistoryScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/import/csv', builder: (_, _) => const CsvImportScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/categories', builder: (_, _) => const CategoriesScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/backup', builder: (_, _) => const BackupScreen()),
      GoRoute(parentNavigatorKey: rootKey, path: '/audit', builder: (_, _) => const AuditScreen()),
    ],
  );
}
