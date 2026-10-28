import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../data/repos/audit_repo.dart';
import '../data/repos/inbox_repo.dart';
import '../data/repos/ledger_repo.dart';
import '../data/repos/settings_repo.dart';
import '../services/backup_service.dart';
import '../services/export_service.dart';
import '../services/ingestion_service.dart';
import '../services/key_store.dart';
import '../services/pin_service.dart';
import '../services/platform_bridge.dart';
import '../services/reminder_service.dart';

/// Overridden in main() once the encrypted database is open.
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('database not opened'));
final initialSettingsProvider = Provider<AppSettings>((ref) => const AppSettings());

final keyStoreProvider = Provider<KeyStore>((ref) => KeyStore());
final pinServiceProvider = Provider<PinService>((ref) => PinService(ref.watch(keyStoreProvider)));
final bridgeProvider = Provider<PlatformBridge>((ref) => PlatformBridge());
final reminderServiceProvider = Provider<ReminderService>((ref) => ReminderService());

final ledgerProvider = Provider<LedgerRepo>((ref) => LedgerRepo(ref.watch(databaseProvider)));
final inboxProvider = Provider<InboxRepo>((ref) => InboxRepo(ref.watch(databaseProvider)));
final auditProvider = Provider<AuditRepo>((ref) => AuditRepo(ref.watch(databaseProvider)));
final settingsRepoProvider = Provider<SettingsRepo>((ref) => SettingsRepo(ref.watch(databaseProvider)));
final backupServiceProvider = Provider<BackupService>((ref) => BackupService(ref.watch(databaseProvider)));
final exportServiceProvider = Provider<ExportService>((ref) => ExportService(ref.watch(ledgerProvider)));

final ingestionProvider = Provider<IngestionService>(
  (ref) => IngestionService(
    ledger: ref.watch(ledgerProvider),
    inbox: ref.watch(inboxProvider),
    audit: ref.watch(auditProvider),
    retention: () => ref.read(settingsProvider).retention,
  ),
);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(initialSettingsProvider);

  Future<void> update(AppSettings Function(AppSettings s) change) async {
    final next = change(state);
    state = next;
    await ref.read(settingsRepoProvider).save(next);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

final capabilitiesProvider = FutureProvider<PlatformCapabilities>((ref) => ref.watch(bridgeProvider).capabilities());

final cardsProvider = StreamProvider<List<CardRow>>((ref) => ref.watch(ledgerProvider).watchCards());
final categoriesProvider = StreamProvider<List<CategoryRow>>((ref) => ref.watch(ledgerProvider).watchCategories());
final sendersProvider = StreamProvider<List<SenderRow>>((ref) => ref.watch(inboxProvider).watchSenders());
final reviewProvider = StreamProvider<List<RawRow>>((ref) => ref.watch(inboxProvider).watchNeedsReview());
final reviewCountProvider = StreamProvider<int>((ref) => ref.watch(inboxProvider).watchNeedsReviewCount());
final duesProvider = StreamProvider<List<DueItem>>((ref) => ref.watch(ledgerProvider).watchUpcomingDues());
final installmentsProvider = StreamProvider<List<InstallmentView>>(
  (ref) => ref.watch(ledgerProvider).watchInstallments(),
);

class MonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void shift(int months) => state = DateTime(state.year, state.month + months);
}

final selectedMonthProvider = NotifierProvider<MonthNotifier, DateTime>(MonthNotifier.new);

final monthSummaryProvider = StreamProvider<MonthSummary>(
  (ref) => ref.watch(ledgerProvider).watchMonth(ref.watch(selectedMonthProvider)),
);

/// Transactions list filter, shared between the list and its filter sheet.
class TxnFilterNotifier extends Notifier<TxnFilter> {
  @override
  TxnFilter build() => const TxnFilter();
  void set(TxnFilter f) => state = f;
}

final txnFilterProvider = NotifierProvider<TxnFilterNotifier, TxnFilter>(TxnFilterNotifier.new);

final transactionsProvider = StreamProvider<List<TxnView>>(
  (ref) => ref.watch(ledgerProvider).watchTransactions(ref.watch(txnFilterProvider)),
);

/// App lock state. Locked at start (after onboarding) and after the app sat
/// in the background longer than the timeout.
class LockState {
  const LockState({required this.locked, this.obscured = false});
  final bool locked;

  /// True while the app is inactive, to hide content in the app switcher.
  final bool obscured;
}

class LockController extends Notifier<LockState> {
  DateTime? _backgroundAt;

  @override
  LockState build() => LockState(locked: ref.read(initialSettingsProvider).onboarded);

  void unlock() => state = const LockState(locked: false);
  void lock() => state = LockState(locked: true, obscured: state.obscured);

  void onLifecycle(AppLifecycleState s) {
    final settings = ref.read(settingsProvider);
    switch (s) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        state = LockState(locked: state.locked, obscured: true);
      case AppLifecycleState.paused:
        _backgroundAt ??= DateTime.now();
        state = LockState(locked: state.locked, obscured: true);
      case AppLifecycleState.resumed:
        final away = _backgroundAt == null ? Duration.zero : DateTime.now().difference(_backgroundAt!);
        _backgroundAt = null;
        final relock = settings.onboarded && away.inSeconds >= settings.lockTimeoutSeconds;
        state = LockState(locked: state.locked || relock, obscured: false);
      case AppLifecycleState.detached:
        break;
    }
  }
}

final lockProvider = NotifierProvider<LockController, LockState>(LockController.new);
