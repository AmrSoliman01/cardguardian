import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

part 'database.g.dart';

// Money columns are integers in minor units. Dates are stored as drift
// DateTime columns (unix seconds). Enum-like columns store the Dart enum name.

@DataClassName('CardRow')
class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankCode => text()();
  TextColumn get last4 => text().withLength(min: 4, max: 4)();
  TextColumn get nickname => text().nullable()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  IntColumn get creditLimitMinor => integer().nullable()();
  IntColumn get statementDay => integer().nullable()();
  IntColumn get dueDay => integer().nullable()();
  IntColumn get lastAvailableMinor => integer().nullable()();
  TextColumn get lastAvailableCurrency => text().nullable()();
  DateTimeColumn get lastAvailableAt => dateTime().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {bankCode, last4},
  ];
}

@DataClassName('TxnRow')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  IntColumn get originalAmountMinor => integer().nullable()();
  TextColumn get originalCurrency => text().nullable()();
  TextColumn get merchant => text()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get occurredAt => dateTime()();
  IntColumn get availableLimitMinor => integer().nullable()();
  TextColumn get sourceType => text()();
  TextColumn get sourceHash => text().unique()();
  TextColumn get parserId => text()();
  IntColumn get parserVersion => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// App-owned copies of incoming messages. Subject to the retention setting.
@DataClassName('RawRow')
class RawMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceType => text()();
  TextColumn get sender => text().nullable()();
  TextColumn get body => text()();
  DateTimeColumn get receivedAt => dateTime()();

  /// pending (waiting for the user), parsed, failed (no parser matched), ignored.
  TextColumn get status => text()();
  TextColumn get bankCode => text().nullable()();
  TextColumn get rawHash => text().unique()();
  IntColumn get transactionId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Senders the user allowed. Anything else is dropped before storage.
@DataClassName('SenderRow')
class Senders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address => text().unique()();
  TextColumn get bankCode => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get mode => text().withDefault(const Constant('auto'))();
  TextColumn get mustContain => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text()();
  IntColumn get icon => integer()();
  IntColumn get color => integer()();
  BoolColumn get builtin => boolean().withDefault(const Constant(false))();
}

@DataClassName('MerchantRuleRow')
class MerchantRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pattern => text().unique()();
  IntColumn get categoryId => integer().references(Categories, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('StatementRow')
class Statements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get periodEnd => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get totalDueMinor => integer()();
  IntColumn get minimumDueMinor => integer().nullable()();
  TextColumn get currency => text()();
  BoolColumn get paid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('InstallmentRow')
class Installments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId => integer().references(Cards, #id, onDelete: KeyAction.cascade)();
  TextColumn get merchant => text()();
  IntColumn get totalMinor => integer()();
  IntColumn get monthlyMinor => integer()();
  TextColumn get currency => text()();
  IntColumn get months => integer()();
  DateTimeColumn get startDate => dateTime()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Local audit trail. Never stores amounts, merchants or message text.
@DataClassName('AuditRow')
class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get event => text()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Cards,
    Transactions,
    RawMessages,
    Senders,
    Categories,
    MerchantRules,
    Statements,
    Installments,
    Settings,
    AuditLog,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement('CREATE INDEX idx_txn_card_time ON transactions (card_id, occurred_at)');
      await customStatement('CREATE INDEX idx_txn_time ON transactions (occurred_at)');
      await customStatement('CREATE INDEX idx_raw_status ON raw_messages (status)');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Thrown when the bundled SQLite library has no encryption support. The app
/// refuses to store financial data in a plain database.
class EncryptionUnavailableError extends Error {
  @override
  String toString() => 'SQLCipher is not available; refusing to open an unencrypted database.';
}

/// Applies the SQLCipher key and hardening pragmas. Runs on the database
/// isolate before any other statement.
void applyCipherKey(sqlite.Database db, String hexKey) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(hexKey)) {
    throw ArgumentError('Database key must be 64 lowercase hex characters');
  }
  final version = db.select('PRAGMA cipher_version');
  if (version.isEmpty || (version.first.values.first as String?)?.isEmpty != false) {
    throw EncryptionUnavailableError();
  }
  // A raw 256-bit key: no passphrase derivation needed.
  db.execute("PRAGMA key = \"x'$hexKey'\"");
  // Fails here, not later, when the key is wrong.
  db.select('SELECT count(*) FROM sqlite_master');
  db.execute('PRAGMA secure_delete = ON');
  db.execute('PRAGMA journal_mode = WAL');
}

/// Opens the encrypted database file on a background isolate.
QueryExecutor openEncrypted(File file, String hexKey) {
  return NativeDatabase.createInBackground(file, setup: (db) => applyCipherKey(db, hexKey));
}
