import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/providers.dart';
import '../../data/repos/audit_repo.dart';
import '../../data/repos/settings_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/widgets.dart';
import '../lock/pin_pad.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SectionTitle(l.appearance),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l.language),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ar', label: Text('عربي')),
                ButtonSegment(value: 'en', label: Text('EN')),
              ],
              selected: {s.localeCode ?? 'ar'},
              onSelectionChanged: (v) => notifier.update((x) => x.copyWith(localeCode: v.first)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l.theme),
            trailing: DropdownButton<ThemeMode>(
              value: s.themeMode,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(l.themeSystem)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(l.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l.themeDark)),
              ],
              onChanged: (v) => notifier.update((x) => x.copyWith(themeMode: v)),
            ),
          ),

          SectionTitle(l.security),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(l.useBiometrics),
            value: s.biometricsEnabled,
            onChanged: (v) async {
              if (v) {
                try {
                  final ok = await LocalAuthentication().authenticate(
                    localizedReason: l.enableBiometricsReason,
                    biometricOnly: true,
                  );
                  if (!ok) return;
                } on LocalAuthException {
                  if (context.mounted) showSnack(context, l.biometricsUnavailable);
                  return;
                }
              }
              await notifier.update((x) => x.copyWith(biometricsEnabled: v));
            },
          ),
          ListTile(
            leading: const Icon(Icons.pin_outlined),
            title: Text(l.changePin),
            onTap: () => _changePin(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l.autoLock),
            trailing: DropdownButton<int>(
              value: s.lockTimeoutSeconds,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: 0, child: Text(l.immediately)),
                DropdownMenuItem(value: 60, child: Text(l.afterMinutes(1))),
                DropdownMenuItem(value: 300, child: Text(l.afterMinutes(5))),
                DropdownMenuItem(value: 900, child: Text(l.afterMinutes(15))),
              ],
              onChanged: (v) => notifier.update((x) => x.copyWith(lockTimeoutSeconds: v)),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.screenshot_monitor_outlined),
            title: Text(l.blockScreenshots),
            subtitle: Text(l.blockScreenshotsHelp),
            value: s.blockScreenshots,
            onChanged: (v) => notifier.update((x) => x.copyWith(blockScreenshots: v)),
          ),

          SectionTitle(l.privacy),
          SwitchListTile(
            secondary: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.maxPrivacy),
            subtitle: Text(l.maxPrivacyHelp),
            value: s.retention == RetentionMode.deleteAfterParse,
            onChanged: (v) async {
              await notifier.update(
                (x) => x.copyWith(retention: v ? RetentionMode.deleteAfterParse : RetentionMode.keep30),
              );
              await ref.read(auditProvider).log(AuditEvent.retentionChanged, {'max': v});
              await ref.read(ingestionProvider).applyRetention();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: Text(l.dueReminders),
            subtitle: Text(l.dueRemindersHelp),
            value: s.remindersEnabled,
            onChanged: (v) async {
              if (v) unawaited(ref.read(reminderServiceProvider).requestPermission());
              await notifier.update((x) => x.copyWith(remindersEnabled: v));
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: Text(l.privacyPromiseTitle),
            subtitle: Text(l.privacyPromiseBody),
          ),

          SectionTitle(l.dangerZone),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
            title: Text(l.deleteAllData, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            subtitle: Text(l.deleteAllDataHelp),
            onTap: () => _deleteAll(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _changePin(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    String? first;
    final pad = GlobalKey<PinPadState>();
    final pin = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => StatefulBuilder(
        builder: (c, set) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(first == null ? l.createPin : l.confirmPin, style: Theme.of(c).textTheme.titleLarge),
                const SizedBox(height: 16),
                PinPad(
                  key: pad,
                  onSubmit: (p) {
                    pad.currentState?.clear();
                    if (first == null) {
                      set(() => first = p);
                    } else if (first == p) {
                      Navigator.pop(c, p);
                    } else {
                      set(() => first = null);
                      showSnack(context, l.pinMismatch);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (pin == null) return;
    await ref.read(pinServiceProvider).setPin(pin);
    await ref.read(auditProvider).log(AuditEvent.pinChanged);
    if (context.mounted) showSnack(context, l.pinChanged);
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    if (!await confirm(context, title: l.deleteAllDataQ, message: l.deleteAllDataConfirm, action: l.delete)) return;
    final db = ref.read(databaseProvider);
    await db.transaction(() async {
      for (final t in [
        'transactions',
        'raw_messages',
        'statements',
        'installments',
        'merchant_rules',
        'cards',
        'senders',
      ]) {
        await db.customStatement('DELETE FROM $t');
      }
    });
    await db.customStatement('VACUUM');
    await ref.read(auditProvider).log(AuditEvent.dataDeleted);
    if (context.mounted) showSnack(context, l.allDataDeleted);
  }
}
