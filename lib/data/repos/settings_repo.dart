import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../db/database.dart';

enum RetentionMode {
  /// Keep the app's copy of message text for 30 days (useful to re-check).
  keep30,

  /// Maximum privacy: delete the app's copy right after a successful parse.
  deleteAfterParse;

  static RetentionMode fromName(String? n) =>
      RetentionMode.values.firstWhere((e) => e.name == n, orElse: () => RetentionMode.keep30);
}

@immutable
class AppSettings {
  const AppSettings({
    this.localeCode,
    this.themeMode = ThemeMode.system,
    this.onboarded = false,
    this.biometricsEnabled = false,
    this.lockTimeoutSeconds = 60,
    this.retention = RetentionMode.keep30,
    this.blockScreenshots = true,
    this.remindersEnabled = true,
    this.notificationPackages = const [],
  });

  /// `ar` or `en`; null until chosen on first launch.
  final String? localeCode;
  final ThemeMode themeMode;
  final bool onboarded;
  final bool biometricsEnabled;
  final int lockTimeoutSeconds;
  final RetentionMode retention;
  final bool blockScreenshots;
  final bool remindersEnabled;

  /// Android apps whose notifications may be read (e.g. the SMS app).
  final List<String> notificationPackages;

  AppSettings copyWith({
    String? localeCode,
    ThemeMode? themeMode,
    bool? onboarded,
    bool? biometricsEnabled,
    int? lockTimeoutSeconds,
    RetentionMode? retention,
    bool? blockScreenshots,
    bool? remindersEnabled,
    List<String>? notificationPackages,
  }) => AppSettings(
    localeCode: localeCode ?? this.localeCode,
    themeMode: themeMode ?? this.themeMode,
    onboarded: onboarded ?? this.onboarded,
    biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    lockTimeoutSeconds: lockTimeoutSeconds ?? this.lockTimeoutSeconds,
    retention: retention ?? this.retention,
    blockScreenshots: blockScreenshots ?? this.blockScreenshots,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    notificationPackages: notificationPackages ?? this.notificationPackages,
  );

  Map<String, String> toMap() => {
    'locale': ?localeCode,
    'theme': themeMode.name,
    'onboarded': '$onboarded',
    'biometrics': '$biometricsEnabled',
    'lockTimeout': '$lockTimeoutSeconds',
    'retention': retention.name,
    'blockScreenshots': '$blockScreenshots',
    'reminders': '$remindersEnabled',
    'notificationPackages': jsonEncode(notificationPackages),
  };

  factory AppSettings.fromMap(Map<String, String> m) => AppSettings(
    localeCode: m['locale'],
    themeMode: ThemeMode.values.firstWhere((e) => e.name == m['theme'], orElse: () => ThemeMode.system),
    onboarded: m['onboarded'] == 'true',
    biometricsEnabled: m['biometrics'] == 'true',
    lockTimeoutSeconds: int.tryParse(m['lockTimeout'] ?? '') ?? 60,
    retention: RetentionMode.fromName(m['retention']),
    blockScreenshots: m['blockScreenshots'] != 'false',
    remindersEnabled: m['reminders'] != 'false',
    notificationPackages: m['notificationPackages'] == null
        ? const []
        : (jsonDecode(m['notificationPackages']!) as List<dynamic>).cast<String>(),
  );
}

class SettingsRepo {
  SettingsRepo(this.db);
  final AppDatabase db;

  Future<AppSettings> load() async {
    final rows = await db.select(db.settings).get();
    return AppSettings.fromMap({for (final r in rows) r.key: r.value});
  }

  Future<void> save(AppSettings s) async {
    await db.batch((b) {
      b.insertAllOnConflictUpdate(db.settings, [
        for (final e in s.toMap().entries) SettingsCompanion.insert(key: e.key, value: e.value),
      ]);
    });
  }

  Future<String?> getRaw(String key) async =>
      (await (db.select(db.settings)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setRaw(String key, String value) =>
      db.into(db.settings).insertOnConflictUpdate(SettingsCompanion(key: Value(key), value: Value(value)));
}
