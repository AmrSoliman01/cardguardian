import 'package:cardguardian/data/db/database.dart';
import 'package:cardguardian/data/repos/audit_repo.dart';
import 'package:cardguardian/data/repos/inbox_repo.dart';
import 'package:cardguardian/data/repos/ledger_repo.dart';
import 'package:cardguardian/data/repos/settings_repo.dart';
import 'package:cardguardian/data/seed.dart';
import 'package:cardguardian/services/backup_service.dart';
import 'package:cardguardian/services/export_service.dart';
import 'package:cardguardian/services/ingestion_service.dart';
import 'package:cardguardian/services/pin_service.dart';
import 'package:cg_core/cg_core.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// Synthetic messages in ABK-Egypt's format.
String _abk(String amount, String merchant, String date, String limit, {String card = '1234'}) =>
    'Your Credit Card#**$card was charged EGP $amount at $merchant on $date at 10:12. '
    'Your available limit is EGP $limit. For more info, call 19322';

RawMessage _sms(String body, {String sender = 'ABK-Egypt', SourceType source = SourceType.sms}) =>
    RawMessage(sourceType: source, sender: sender, body: body, receivedAt: DateTime(2026, 10, 28));

void main() {
  late AppDatabase db;
  late LedgerRepo ledger;
  late InboxRepo inbox;
  late IngestionService svc;
  var retention = RetentionMode.keep30;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedDefaults(db);
    ledger = LedgerRepo(db);
    inbox = InboxRepo(db);
    retention = RetentionMode.keep30;
    svc = IngestionService(ledger: ledger, inbox: inbox, audit: AuditRepo(db), retention: () => retention);
  });
  tearDown(() => db.close());

  test('nothing is read until the user allows a sender', () async {
    final r = await svc.ingest([_sms(_abk('100.00', 'SHOP', '26/10/26', '900'))]);
    expect(r.ignored, 1);
    expect(await db.select(db.transactions).get(), isEmpty);
    expect(await db.select(db.rawMessages).get(), isEmpty, reason: 'ignored messages are never stored');
  });

  test('allowed sender: parses, creates the card, categorizes, dedups', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG', mustContain: 'Credit Card#');
    final msgs = [
      _sms(_abk('100.00', 'GOOGLE*GOOGLE', '26/10/26', '900')),
      _sms(_abk('50.50', 'Talabat', '27/10/26', '849.50')),
      _sms('Your OTP is 1234'),
      _sms(_abk('1.00', 'X', '27/10/26', '1'), sender: 'Spam'),
    ];
    final r = await svc.ingest(msgs);
    expect(r.added, 2);
    expect(r.ignored, 2);

    final cards = await ledger.cards();
    expect(cards.single.last4, '1234');
    expect(cards.single.lastAvailableMinor, 84950, reason: 'latest message wins');

    final txns = await ledger.watchTransactions(const TxnFilter()).first;
    expect(txns.map((t) => t.category?.key), containsAll([CategoryKeys.subscriptions, CategoryKeys.dining]));

    // Same alert pasted later is not stored twice.
    final again = await svc.ingest([_sms(msgs.first.body, source: SourceType.paste)]);
    expect(again.duplicates, 1);
    expect((await ledger.watchTransactions(const TxnFilter()).first).length, 2);
  });

  test('review mode holds messages until approved', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG', mode: SenderMode.review);
    final r = await svc.ingest([_sms(_abk('100.00', 'SHOP', '26/10/26', '900'))]);
    expect(r.review, 1);
    final held = await inbox.watchNeedsReview().first;
    expect(held.single.status, RawStatus.pending.name);

    expect(await svc.approve(held.single.id, held.single.toMessage()), isTrue);
    expect(await inbox.watchNeedsReview().first, isEmpty);
    expect((await ledger.watchTransactions(const TxnFilter()).first).single.txn.amountMinor, 10000);
  });

  test('unknown format goes to review as failed and can be completed by hand', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    final r = await svc.ingest([_sms('Your Credit Card#**1234 payment of EGP 500 received')]);
    expect(r.failed, 1);
    final held = (await inbox.watchNeedsReview().first).single;
    await svc.completeManually(
      held.id,
      ParsedTransaction(
        bankCode: 'ABK_EG',
        last4: '1234',
        type: TxnType.payment,
        amountMinor: 50000,
        currency: 'EGP',
        merchant: 'Payment',
        occurredAt: DateTime(2026, 10, 28),
        parserId: 'manual',
        parserVersion: 1,
      ),
      SourceType.sms,
    );
    expect(await inbox.watchNeedsReview().first, isEmpty);
  });

  test('maximum privacy keeps no message text', () async {
    retention = RetentionMode.deleteAfterParse;
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    await svc.ingest([_sms(_abk('100.00', 'SHOP', '26/10/26', '900'))]);
    expect(await db.select(db.rawMessages).get(), isEmpty);
    expect(await db.select(db.transactions).get(), hasLength(1));
  });

  test('retention purge removes handled copies only', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    await svc.ingest([_sms(_abk('100.00', 'SHOP', '26/10/26', '900')), _sms('Your Credit Card#**1234 something new')]);
    expect(await db.select(db.rawMessages).get(), hasLength(2));
    retention = RetentionMode.deleteAfterParse;
    await svc.applyRetention();
    final left = await db.select(db.rawMessages).get();
    expect(left.single.status, RawStatus.failed.name);
  });

  test('month summary: spend, refunds and categories', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    await svc.ingest([
      _sms(_abk('100.00', 'GOOGLE*GOOGLE', '26/10/26', '900')),
      _sms(_abk('40.00', 'Talabat', '27/10/26', '860')),
      _sms(_abk('999.00', 'Old', '27/09/26', '1')),
    ]);
    final s = await ledger.watchMonth(DateTime(2026, 10)).first;
    expect(s.spendMinor, 14000);
    expect(s.count, 2);
    expect(s.byCategory.first.minor, 10000);
    expect(s.dailySpend[25], 10000);
    expect(s.topMerchants.first.merchant, 'GOOGLE*GOOGLE');
  });

  test('remembering a merchant category applies to past rows', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    await svc.ingest([
      _sms(_abk('10.00', 'Corner Shop', '26/10/26', '900')),
      _sms(_abk('20.00', 'Corner Shop', '27/10/26', '880')),
    ]);
    final cats = await ledger.watchCategories().first;
    final groceries = cats.firstWhere((c) => c.key == CategoryKeys.groceries);
    final txns = await ledger.watchTransactions(const TxnFilter()).first;
    await ledger.setCategory(txns.first.txn.id, groceries.id, rememberMerchant: true);
    final after = await ledger.watchTransactions(const TxnFilter()).first;
    expect(after.every((t) => t.txn.categoryId == groceries.id), isTrue);
  });

  test('CSV export escapes formulas', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    await svc.ingest([_sms(_abk('10.00', '=HYPERLINK(x)', '26/10/26', '900'))]);
    final csv = await ExportService(ledger).transactionsCsv();
    expect(csv, contains("'=HYPERLINK(x)"));
    expect(csv, contains('10.00,EGP'));
  });

  test('encrypted backup round-trip and wrong passphrase', () async {
    await inbox.addSender(address: 'ABK-Egypt', bankCode: 'ABK_EG');
    await svc.ingest([_sms(_abk('10.00', 'SHOP', '26/10/26', '900'))]);
    final backup = BackupService(db, kdf: const KdfParams(memoryKiB: 1024, iterations: 1));
    final bytes = await backup.createBackup('correct horse');
    expect(String.fromCharCodes(bytes).contains('SHOP'), isFalse);

    await expectLater(backup.readBackup(bytes, 'wrong'), throwsA(isA<WrongPassphraseError>()));
    final tampered = Uint8List.fromList(bytes)..[bytes.length - 20] ^= 1;
    await expectLater(backup.readBackup(tampered, 'correct horse'), throwsA(isA<WrongPassphraseError>()));

    final data = await backup.readBackup(bytes, 'correct horse');
    await db.delete(db.transactions).go();
    await db.delete(db.cards).go();
    await backup.restore(data);
    final txns = await ledger.watchTransactions(const TxnFilter()).first;
    expect(txns.single.txn.merchant, 'SHOP');
    expect(txns.single.card.last4, '1234');
    expect(await db.select(db.senders).get(), hasLength(1));
  });

  test('upcoming dues from statements and card due day', () async {
    final a = await ledger.ensureCard('ABK_EG', '1234');
    final b = await ledger.ensureCard('CIB_EG', '5678');
    await ledger.updateCard(CardsCompanion(id: Value(b), dueDay: const Value(15)));
    final due = DateTime.now().add(const Duration(days: 5));
    await ledger.addStatement(
      StatementsCompanion.insert(
        cardId: a,
        periodEnd: DateTime.now(),
        dueDate: DateTime(due.year, due.month, due.day),
        totalDueMinor: 500000,
        currency: 'EGP',
      ),
    );
    final items = await ledger.watchUpcomingDues().first;
    expect(items, hasLength(2));
    expect(items.firstWhere((i) => i.card.id == a).amountMinor, 500000);
    expect(items.firstWhere((i) => i.card.id == b).estimated, isTrue);
  });
}
