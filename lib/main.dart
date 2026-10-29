import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/providers.dart';
import 'data/db/database.dart';
import 'data/repos/settings_repo.dart';
import 'data/seed.dart';
import 'services/key_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  try {
    final key = await KeyStore().databaseKey();
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'cardguardian.db'));
    final db = AppDatabase(openEncrypted(file, key));
    await seedDefaults(db);
    final settings = await SettingsRepo(db).load();

    runApp(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), initialSettingsProvider.overrideWithValue(settings)],
        child: const CardGuardianApp(),
      ),
    );
  } catch (e) {
    runApp(StartupErrorApp(error: e));
  }
}

/// Shown when the encrypted database cannot be opened. The app never falls
/// back to an unencrypted store.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 56),
              const SizedBox(height: 16),
              const Text('CardGuardian could not open its encrypted storage.', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(
                'تعذر فتح قاعدة البيانات المشفرة.',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),
              Text('$error', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}
