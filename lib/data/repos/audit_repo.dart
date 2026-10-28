import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/database.dart';

/// Security-relevant events, stored inside the encrypted database.
/// Details hold counts and setting names only, never amounts or text.
enum AuditEvent {
  appSetup,
  pinChanged,
  unlockFailed,
  sourceEnabled,
  sourceDisabled,
  importCompleted,
  exportCreated,
  backupCreated,
  backupRestored,
  dataDeleted,
  retentionChanged,
  deviceIntegrityWarning,
}

class AuditRepo {
  AuditRepo(this.db);
  final AppDatabase db;

  Future<void> log(AuditEvent event, [Map<String, Object?>? details]) => db
      .into(db.auditLog)
      .insert(
        AuditLogCompanion.insert(event: event.name, details: Value(details == null ? null : jsonEncode(details))),
      );

  Stream<List<AuditRow>> watchRecent({int limit = 200}) =>
      (db.select(db.auditLog)
            ..orderBy([(a) => OrderingTerm.desc(a.at)])
            ..limit(limit))
          .watch();
}
