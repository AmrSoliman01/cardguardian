import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../data/db/database.dart';
import 'pin_service.dart';

class BackupFormatError implements Exception {
  const BackupFormatError(this.message);
  final String message;
  @override
  String toString() => 'BackupFormatError: $message';
}

class WrongPassphraseError implements Exception {
  const WrongPassphraseError();
}

/// Encrypted backups: every table as JSON, gzip, AES-256-GCM with a key
/// derived from the user's passphrase (Argon2id). File layout:
///
///   CGBACKUP1\n
///   {"kdf":{...},"salt":"...","nonce":"..."}\n
///   ciphertext + 16-byte GCM tag
class BackupService {
  BackupService(this.db, {this.kdf = const KdfParams(memoryKiB: 19456, iterations: 2)});

  final AppDatabase db;
  final KdfParams kdf;

  static const _magic = 'CGBACKUP1';
  static const _tables = [
    'categories',
    'cards',
    'senders',
    'merchant_rules',
    'transactions',
    'raw_messages',
    'statements',
    'installments',
    'settings',
    'audit_log',
  ];

  Future<Map<String, Object?>> _dump() async {
    final out = <String, Object?>{'schema': db.schemaVersion, 'createdAt': DateTime.now().toIso8601String()};
    for (final t in _tables) {
      final rows = await db.customSelect('SELECT * FROM $t').get();
      out[t] = [for (final r in rows) r.data];
    }
    return out;
  }

  Future<Uint8List> createBackup(String passphrase) async {
    final plain = gzip.encode(utf8.encode(jsonEncode(await _dump())));
    final salt = randomBytes(16);
    final key = await deriveKey(passphrase, salt, kdf);
    final aes = AesGcm.with256bits();
    final nonce = aes.newNonce();
    final header = jsonEncode({'kdf': kdf.toJson(), 'salt': base64Encode(salt), 'nonce': base64Encode(nonce)});
    final box = await aes.encrypt(plain, secretKey: SecretKey(key), nonce: nonce, aad: utf8.encode(header));
    final b = BytesBuilder(copy: false)
      ..add(utf8.encode('$_magic\n$header\n'))
      ..add(box.cipherText)
      ..add(box.mac.bytes);
    return b.toBytes();
  }

  /// Decrypts [bytes]. Throws [WrongPassphraseError] or [BackupFormatError].
  Future<Map<String, Object?>> readBackup(Uint8List bytes, String passphrase) async {
    final first = bytes.indexOf(10);
    if (first < 0 || utf8.decode(bytes.sublist(0, first)) != _magic) {
      throw const BackupFormatError('not a CardGuardian backup');
    }
    final second = bytes.indexOf(10, first + 1);
    if (second < 0) throw const BackupFormatError('truncated header');
    final headerText = utf8.decode(bytes.sublist(first + 1, second));
    final header = jsonDecode(headerText) as Map<String, Object?>;
    final body = bytes.sublist(second + 1);
    if (body.length < 16) throw const BackupFormatError('truncated body');

    final key = await deriveKey(
      passphrase,
      base64Decode(header['salt']! as String),
      KdfParams.fromJson((header['kdf']! as Map).cast<String, Object?>()),
    );
    final box = SecretBox(
      body.sublist(0, body.length - 16),
      nonce: base64Decode(header['nonce']! as String),
      mac: Mac(body.sublist(body.length - 16)),
    );
    try {
      final plain = await AesGcm.with256bits().decrypt(box, secretKey: SecretKey(key), aad: utf8.encode(headerText));
      return jsonDecode(utf8.decode(gzip.decode(plain))) as Map<String, Object?>;
    } on SecretBoxAuthenticationError {
      throw const WrongPassphraseError();
    }
  }

  /// Replaces all data with the backup's contents, in one transaction.
  Future<void> restore(Map<String, Object?> data) async {
    final schema = data['schema'] as int?;
    if (schema == null || schema > db.schemaVersion) {
      throw const BackupFormatError('backup is from a newer app version');
    }
    await db.transaction(() async {
      await db.customStatement('PRAGMA defer_foreign_keys = ON');
      for (final t in _tables.reversed) {
        await db.customStatement('DELETE FROM $t');
      }
      for (final t in _tables) {
        final rows = (data[t] as List<Object?>? ?? const []).cast<Map<String, Object?>>();
        for (final r in rows) {
          final cols = r.keys.toList();
          if (cols.any((c) => !RegExp(r'^[a-z_0-9]+$').hasMatch(c))) {
            throw const BackupFormatError('bad column name');
          }
          await db.customInsert(
            'INSERT INTO $t (${cols.join(', ')}) VALUES (${List.filled(cols.length, '?').join(', ')})',
            variables: [for (final c in cols) _variable(r[c])],
          );
        }
      }
    });
  }

  static Variable<Object> _variable(Object? v) => switch (v) {
    null => const Variable(null),
    int i => Variable<int>(i),
    double d => Variable<double>(d),
    bool b => Variable<bool>(b),
    String s => Variable<String>(s),
    _ => throw const BackupFormatError('unsupported value'),
  };
}
