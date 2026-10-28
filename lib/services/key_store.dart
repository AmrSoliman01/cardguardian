import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secrets kept in the iOS Keychain / Android Keystore. They never leave the
/// device: not synced to iCloud, excluded from backups.
class KeyStore {
  KeyStore([FlutterSecureStorage? storage])
    : _s =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device, synchronizable: false),
            // Never silently wipe secrets on a decryption error: losing the
            // database key would make all data unreadable.
            aOptions: AndroidOptions(resetOnError: false),
          );

  final FlutterSecureStorage _s;

  static const _dbKey = 'cg.db.key.v1';
  static const _pin = 'cg.pin.v1';
  static const _pinFails = 'cg.pin.fails.v1';

  /// The SQLCipher key: 32 random bytes as lowercase hex. Created once.
  Future<String> databaseKey() async {
    final existing = await _s.read(key: _dbKey);
    if (existing != null) return existing;
    final key = randomHex(32);
    await _s.write(key: _dbKey, value: key);
    return key;
  }

  Future<Map<String, Object?>?> readPinRecord() async {
    final v = await _s.read(key: _pin);
    return v == null ? null : jsonDecode(v) as Map<String, Object?>;
  }

  Future<void> writePinRecord(Map<String, Object?> record) => _s.write(key: _pin, value: jsonEncode(record));

  Future<Map<String, Object?>> readFailures() async {
    final v = await _s.read(key: _pinFails);
    return v == null ? <String, Object?>{} : jsonDecode(v) as Map<String, Object?>;
  }

  Future<void> writeFailures(Map<String, Object?> v) => _s.write(key: _pinFails, value: jsonEncode(v));

  /// Removes PIN data (used by "delete all data"). The database key stays so
  /// the emptied database can still be opened.
  Future<void> clearPin() async {
    await _s.delete(key: _pin);
    await _s.delete(key: _pinFails);
  }
}

String randomHex(int bytes) {
  final r = Random.secure();
  return List.generate(bytes, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}
