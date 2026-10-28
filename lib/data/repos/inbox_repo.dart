import 'package:cg_core/cg_core.dart';
import 'package:drift/drift.dart';

import '../db/database.dart';

enum RawStatus { pending, parsed, failed, ignored }

extension SenderRowRule on SenderRow {
  SenderRule toRule() => SenderRule(
    address: address,
    bankCode: bankCode,
    enabled: enabled,
    mode: SenderMode.fromName(mode),
    mustContain: mustContain,
  );
}

extension RawRowMessage on RawRow {
  RawMessage toMessage() =>
      RawMessage(sourceType: SourceType.fromName(sourceType), sender: sender, body: body, receivedAt: receivedAt);
}

/// Allowed senders and the app's own copies of incoming messages.
class InboxRepo {
  InboxRepo(this.db);
  final AppDatabase db;

  // --------------------------------------------------------------- senders

  Stream<List<SenderRow>> watchSenders() =>
      (db.select(db.senders)..orderBy([(s) => OrderingTerm.asc(s.createdAt)])).watch();

  Future<List<SenderRow>> senders() => db.select(db.senders).get();

  Future<List<SenderRule>> rules() async => [for (final s in await senders()) s.toRule()];

  Future<int> addSender({
    required String address,
    required String bankCode,
    SenderMode mode = SenderMode.auto,
    String? mustContain,
  }) => db
      .into(db.senders)
      .insert(
        SendersCompanion.insert(
          address: address.trim(),
          bankCode: bankCode,
          mode: Value(mode.name),
          mustContain: Value(_blankToNull(mustContain)),
        ),
        mode: InsertMode.insertOrReplace,
      );

  Future<void> updateSender(
    int id, {
    String? address,
    String? bankCode,
    bool? enabled,
    SenderMode? mode,
    String? mustContain,
    bool clearFilter = false,
  }) => (db.update(db.senders)..where((s) => s.id.equals(id))).write(
    SendersCompanion(
      address: address == null ? const Value.absent() : Value(address.trim()),
      bankCode: Value.absentIfNull(bankCode),
      enabled: Value.absentIfNull(enabled),
      mode: mode == null ? const Value.absent() : Value(mode.name),
      mustContain: clearFilter
          ? const Value(null)
          : (mustContain == null ? const Value.absent() : Value(_blankToNull(mustContain))),
    ),
  );

  Future<void> deleteSender(int id) => (db.delete(db.senders)..where((s) => s.id.equals(id))).go();

  static String? _blankToNull(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();

  // ---------------------------------------------------------- raw messages

  /// Stores a raw message once. Returns the existing row id if the same
  /// sender + text is already stored.
  Future<(int id, bool isNew)> saveRaw(RawMessage m, RawStatus status, {String? bankCode}) async {
    final hash = rawMessageHash(m);
    final existing = await (db.select(db.rawMessages)..where((r) => r.rawHash.equals(hash))).getSingleOrNull();
    if (existing != null) return (existing.id, false);
    final id = await db
        .into(db.rawMessages)
        .insert(
          RawMessagesCompanion.insert(
            sourceType: m.sourceType.name,
            sender: Value(m.sender),
            body: m.body,
            receivedAt: m.receivedAt,
            status: status.name,
            bankCode: Value(bankCode),
            rawHash: hash,
          ),
        );
    return (id, true);
  }

  Future<RawRow?> rawByHash(String hash) =>
      (db.select(db.rawMessages)..where((r) => r.rawHash.equals(hash))).getSingleOrNull();

  Future<void> setRawStatus(int id, RawStatus status, {int? transactionId}) =>
      (db.update(db.rawMessages)..where((r) => r.id.equals(id))).write(
        RawMessagesCompanion(status: Value(status.name), transactionId: Value.absentIfNull(transactionId)),
      );

  Future<void> deleteRaw(int id) => (db.delete(db.rawMessages)..where((r) => r.id.equals(id))).go();

  /// Messages that need the user: held for review or not understood.
  Stream<List<RawRow>> watchNeedsReview() =>
      (db.select(db.rawMessages)
            ..where((r) => r.status.isIn([RawStatus.pending.name, RawStatus.failed.name]))
            ..orderBy([(r) => OrderingTerm.desc(r.receivedAt)]))
          .watch();

  Stream<int> watchNeedsReviewCount() {
    final c = db.rawMessages.id.count();
    return (db.selectOnly(db.rawMessages)
          ..addColumns([c])
          ..where(db.rawMessages.status.isIn([RawStatus.pending.name, RawStatus.failed.name])))
        .map((r) => r.read(c) ?? 0)
        .watchSingle();
  }

  /// Applies the retention setting: drops the app's copies of message text
  /// that were already turned into transactions (or ignored).
  Future<int> purgeHandled({Duration? olderThan}) {
    final q = db.delete(db.rawMessages)..where((r) => r.status.isIn([RawStatus.parsed.name, RawStatus.ignored.name]));
    if (olderThan != null) {
      final cutoff = DateTime.now().subtract(olderThan);
      q.where((r) => r.createdAt.isSmallerThanValue(cutoff));
    }
    return q.go();
  }
}
