import 'package:cg_core/cg_core.dart';

import '../data/repos/audit_repo.dart';
import '../data/repos/inbox_repo.dart';
import '../data/repos/ledger_repo.dart';
import '../data/repos/settings_repo.dart';

class IngestReport {
  int added = 0;
  int duplicates = 0;
  int review = 0;
  int ignored = 0;
  int failed = 0;

  int get total => added + duplicates + review + ignored + failed;

  void addAll(IngestReport o) {
    added += o.added;
    duplicates += o.duplicates;
    review += o.review;
    ignored += o.ignored;
    failed += o.failed;
  }

  Map<String, int> toMap() => {
    'added': added,
    'duplicates': duplicates,
    'review': review,
    'ignored': ignored,
    'failed': failed,
  };

  @override
  String toString() => 'IngestReport(${toMap()})';
}

/// The single pipeline every source goes through:
/// sender gate -> parse -> dedup -> store (or hold for review).
class IngestionService {
  IngestionService({
    required this.ledger,
    required this.inbox,
    required this.audit,
    required this.retention,
    ParserRegistry? registry,
  }) : registry = registry ?? ParserRegistry.defaults();

  final LedgerRepo ledger;
  final InboxRepo inbox;
  final AuditRepo audit;
  final RetentionMode Function() retention;
  final ParserRegistry registry;

  /// Ingests [messages]. [bankCode] restricts parsing to one bank (used when
  /// the user picked the bank on the paste screen). [userPicked] means the
  /// user ticked these exact messages (history import), so sender rules and
  /// review mode are skipped for them.
  Future<IngestReport> ingest(List<RawMessage> messages, {String? bankCode, bool userPicked = false}) async {
    final report = IngestReport();
    if (messages.isEmpty) return report;
    final gate = IngestionGate(await inbox.rules());
    final userRules = await ledger.userMerchantRules();

    for (final m in messages) {
      final parsed = registry.parse(m, bankCode: bankCode);
      final detected = parsed is ParseSuccess ? parsed.transaction.bankCode : null;
      final decision = userPicked
          ? GateDecision(GateAction.parse, bankCode: detected, reason: 'user-picked')
          : gate.decide(m, detectedBankCode: detected);

      switch (decision.action) {
        case GateAction.ignore:
          report.ignored++;
        case GateAction.review:
          final (_, isNew) = await inbox.saveRaw(m, RawStatus.pending, bankCode: decision.bankCode ?? detected);
          if (isNew) report.review++;
        case GateAction.parse:
          await _store(m, parsed, report, userRules, bankCode: decision.bankCode ?? bankCode);
      }
    }

    if (report.total > 0) {
      await audit.log(AuditEvent.importCompleted, {'source': messages.first.sourceType.name, ...report.toMap()});
    }
    return report;
  }

  Future<void> _store(
    RawMessage m,
    ParseResult parsed,
    IngestReport report,
    List<MerchantRule> userRules, {
    String? bankCode,
  }) async {
    switch (parsed) {
      case ParseSuccess(:final transaction):
        final r = await ledger.insertParsed(transaction, m.sourceType, userRules: userRules);
        if (r.outcome == InsertOutcome.duplicate) {
          report.duplicates++;
        } else {
          report.added++;
        }
        if (retention() != RetentionMode.deleteAfterParse) {
          final (id, _) = await inbox.saveRaw(m, RawStatus.parsed, bankCode: transaction.bankCode);
          await inbox.setRawStatus(id, RawStatus.parsed, transactionId: r.id);
        }
      case ParseIgnored():
        report.ignored++;
      case ParseNoMatch():
        final (_, isNew) = await inbox.saveRaw(m, RawStatus.failed, bankCode: bankCode);
        if (isNew) report.failed++;
    }
  }

  /// Tries to parse a held message again (after the user approves it).
  /// Returns true when it became a transaction.
  Future<bool> approve(int rawId, RawMessage m, {String? bankCode}) async {
    final parsed = registry.parse(m, bankCode: bankCode);
    if (parsed is! ParseSuccess) {
      await inbox.setRawStatus(rawId, RawStatus.failed);
      return false;
    }
    final r = await ledger.insertParsed(parsed.transaction, m.sourceType);
    await _afterHandled(rawId, r.id);
    return true;
  }

  /// Stores a transaction the user typed in for a message no parser understood.
  Future<void> completeManually(int rawId, ParsedTransaction t, SourceType source) async {
    final r = await ledger.insertParsed(t, source);
    await _afterHandled(rawId, r.id);
  }

  Future<void> ignore(int rawId) async {
    if (retention() == RetentionMode.deleteAfterParse) {
      await inbox.deleteRaw(rawId);
    } else {
      await inbox.setRawStatus(rawId, RawStatus.ignored);
    }
  }

  Future<void> _afterHandled(int rawId, int? txnId) async {
    if (retention() == RetentionMode.deleteAfterParse) {
      await inbox.deleteRaw(rawId);
    } else {
      await inbox.setRawStatus(rawId, RawStatus.parsed, transactionId: txnId);
    }
  }

  /// Applies the retention setting to stored message text.
  Future<int> applyRetention() => switch (retention()) {
    RetentionMode.deleteAfterParse => inbox.purgeHandled(),
    RetentionMode.keep30 => inbox.purgeHandled(olderThan: const Duration(days: 30)),
  };
}
