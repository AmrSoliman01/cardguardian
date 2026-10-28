import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'core/sync.dart';
import 'features/lock/lock_screen.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'ui/theme.dart';

class CardGuardianApp extends ConsumerStatefulWidget {
  const CardGuardianApp({super.key});

  @override
  ConsumerState<CardGuardianApp> createState() => _CardGuardianAppState();
}

class _CardGuardianAppState extends ConsumerState<CardGuardianApp> with WidgetsBindingObserver {
  late final GoRouter _router = buildRouter(ref);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final bridge = ref.read(bridgeProvider);
    bridge.listen(onPendingAvailable: () => unawaited(ref.read(syncProvider).drain()));
    unawaited(bridge.setSecureScreen(ref.read(settingsProvider).blockScreenshots));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(lockProvider.notifier).onLifecycle(state);
    if (state == AppLifecycleState.resumed && !ref.read(lockProvider).locked) {
      unawaited(ref.read(syncProvider).drain());
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    // Keeps native filters, reminders and imports in step with the data.
    ref.watch(syncBootstrapProvider);
    ref.listen(lockProvider, (prev, next) {
      if (prev?.locked == true && !next.locked) unawaited(ref.read(syncProvider).drain());
    });

    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: settings.themeMode,
      locale: settings.localeCode == null ? null : Locale(settings.localeCode!),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => _Guard(child: child ?? const SizedBox()),
    );
  }
}

/// Puts the lock screen and the app-switcher cover above every route.
class _Guard extends ConsumerWidget {
  const _Guard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(lockProvider);
    final onboarded = ref.watch(settingsProvider.select((s) => s.onboarded));
    return Stack(
      children: [
        child,
        if (onboarded && lock.locked) const Positioned.fill(child: LockScreen()),
        if (lock.obscured && onboarded) const Positioned.fill(child: _PrivacyCover()),
      ],
    );
  }
}

class _PrivacyCover extends StatelessWidget {
  const _PrivacyCover();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: Center(child: Icon(Icons.shield_outlined, size: 72, color: Theme.of(context).colorScheme.primary)),
  );
}
