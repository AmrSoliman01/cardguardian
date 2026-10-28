import 'dart:io';

import 'package:cardguardian/data/db/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

const _key = '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
const _wrong = 'ffeeddccbbaa99887766554433221100ffeeddccbbaa99887766554433221100';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('cg_db'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('SQLCipher is bundled', () {
    final db = sqlite.sqlite3.openInMemory();
    final v = db.select('PRAGMA cipher_version');
    expect(v, isNotEmpty);
    db.close();
  });

  test('database file is unreadable without the key', () async {
    final file = File('${dir.path}/cg.db');
    final db = AppDatabase(openEncrypted(file, _key));
    await db.into(db.settings).insert(SettingsCompanion.insert(key: 'k', value: 'secret-value'));
    await db.close();

    // The plaintext never appears on disk.
    final bytes = file.readAsBytesSync();
    expect(String.fromCharCodes(bytes).contains('secret-value'), isFalse);
    expect(String.fromCharCodes(bytes.take(15)), isNot('SQLite format 3'));

    // Plain SQLite (no key) cannot read it.
    final plain = sqlite.sqlite3.open(file.path);
    expect(() => plain.select('SELECT * FROM settings'), throwsA(isA<sqlite.SqliteException>()));
    plain.close();

    // A wrong key fails at open.
    final wrong = sqlite.sqlite3.open(file.path);
    expect(() => applyCipherKey(wrong, _wrong), throwsA(isA<sqlite.SqliteException>()));
    wrong.close();

    // The right key reads it back.
    final again = AppDatabase(openEncrypted(file, _key));
    final rows = await again.select(again.settings).get();
    expect(rows.single.value, 'secret-value');
    await again.close();
  });

  test('rejects malformed keys', () {
    final db = sqlite.sqlite3.openInMemory();
    expect(() => applyCipherKey(db, "abc'; DROP"), throwsArgumentError);
    db.close();
  });
}
