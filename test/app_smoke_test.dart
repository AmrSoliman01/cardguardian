import 'package:cardguardian/app.dart';
import 'package:cardguardian/core/providers.dart';
import 'package:cardguardian/data/db/database.dart';
import 'package:cardguardian/data/repos/settings_repo.dart';
import 'package:cardguardian/data/seed.dart';
import 'package:cardguardian/services/key_store.dart';
import 'package:cardguardian/services/pin_service.dart';
import 'package:cg_core/cg_core.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const _msg =
    'Your Credit Card#**1234 was charged EGP 1500.00 at GOOGLE*GOOGLE on 26/10/26 at 10:12. '
    'Your available limit is EGP 18500. For more info, call 19322';

void main() {
  late AppDatabase db;

  setUpAll(() async => initializeDateFormatting());

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    await seedDefaults(db);
  });

  Future<void> pumpApp(WidgetTester tester, AppSettings settings) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialSettingsProvider.overrideWithValue(settings),
          pinServiceProvider.overrideWithValue(
            PinService(KeyStore(), params: const KdfParams(memoryKiB: 64, iterations: 1)),
          ),
        ],
        child: const CardGuardianApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  /// Drift stream cleanup runs on timers, so the database is closed inside
  /// the fake-async zone while pumping.
  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    final f = db.close();
    await tester.pump(const Duration(seconds: 1));
    await f;
  }

  testWidgets('first launch shows the language picker, then Arabic onboarding', (tester) async {
    await pumpApp(tester, const AppSettings());
    expect(find.text('العربية'), findsOneWidget);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(find.text('بيانات كروتك بتفضل على موبايلك بس'), findsOneWidget);
    await close(tester);
  });

  testWidgets('locked app unlocks with the PIN and shows the dashboard', (tester) async {
    await tester.runAsync(() async {
      await PinService(KeyStore(), params: const KdfParams(memoryKiB: 64, iterations: 1)).setPin('2468');
      final svcDb = db;
      await svcDb.into(svcDb.senders).insert(SendersCompanion.insert(address: 'ABK-Egypt', bankCode: 'ABK_EG'));
    });
    await pumpApp(tester, const AppSettings(onboarded: true, localeCode: 'en'));
    expect(find.text('Enter your PIN'), findsOneWidget);

    for (final d in ['2', '4', '6', '8']) {
      await tester.tap(find.text(d).last);
      await tester.pump();
    }
    await tester.tap(find.text('OK'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
    await tester.pumpAndSettle();
    expect(find.text('Enter your PIN'), findsNothing);
    expect(find.text('No cards yet'), findsOneWidget);
    await close(tester);
  });

  testWidgets('dashboard and transactions render imported data in Arabic (RTL)', (tester) async {
    await tester.runAsync(() async {
      final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
      await container.read(inboxProvider).addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
      await container.read(ingestionProvider).ingest([
        RawMessage(sourceType: SourceType.sms, sender: 'ABK-Egypt', body: _msg, receivedAt: DateTime(2026, 10, 26)),
      ]);
      container.dispose();
    });
    await pumpApp(tester, const AppSettings(onboarded: true, localeCode: 'ar'));
    // Skip the lock screen for this test.
    final element = tester.element(find.byType(CardGuardianApp));
    ProviderScope.containerOf(element).read(lockProvider.notifier).unlock();
    ProviderScope.containerOf(element)
        .read(selectedMonthProvider.notifier)
        .shift((2026 - DateTime.now().year) * 12 + 10 - DateTime.now().month);
    await tester.pumpAndSettle();
    expect(find.text('الملخص'), findsWidgets);
    expect(find.textContaining('18,500.00'), findsWidgets);

    await tester.tap(find.text('المعاملات').last);
    await tester.pumpAndSettle();
    expect(find.text('GOOGLE*GOOGLE'), findsOneWidget);

    await tester.tap(find.text('المزيد').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('المصادر'));
    await tester.pumpAndSettle();
    expect(find.text('ABK-Egypt'), findsOneWidget);
    await close(tester);
  });
}
