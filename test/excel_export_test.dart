import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cardguardian/data/db/database.dart';
import 'package:cardguardian/data/repos/ledger_repo.dart';
import 'package:cardguardian/data/seed.dart';
import 'package:cardguardian/services/excel_export_service.dart';
import 'package:cardguardian/services/xlsx_writer.dart';
import 'package:cg_core/cg_core.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

// All data here is synthetic.
ParsedTransaction _t(TxnType type, int minor, String merchant, DateTime at, {String currency = 'EGP'}) =>
    ParsedTransaction(
      bankCode: 'ABK_EG',
      last4: '1234',
      type: type,
      amountMinor: minor,
      currency: currency,
      merchant: merchant,
      occurredAt: at,
      parserId: 'test',
      parserVersion: 1,
    );

void main() {
  late AppDatabase db;
  late LedgerRepo ledger;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await seedDefaults(db);
    ledger = LedgerRepo(db);
  });
  tearDown(() => db.close());

  String sheetXml(Archive a, int n) => utf8.decode(a.findFile('xl/worksheets/sheet$n.xml')!.content as List<int>);

  test('exports statements, payments and purchases in the template layout', () async {
    final cardId = await ledger.ensureCard('ABK_EG', '1234');
    await ledger.insertParsed(_t(TxnType.purchase, 1025050, 'Test Market', DateTime(2026, 9, 10, 12)), SourceType.sms);
    await ledger.insertParsed(
      _t(TxnType.purchase, 1999, 'Web Shop', DateTime(2026, 9, 11), currency: 'USD'),
      SourceType.sms,
    );
    await ledger.insertParsed(_t(TxnType.refund, 500, 'Test Market', DateTime(2026, 9, 12)), SourceType.manual);
    await ledger.insertParsed(_t(TxnType.payment, 500000, 'Payment', DateTime(2026, 10, 1)), SourceType.manual);
    await db
        .into(db.statements)
        .insert(
          StatementsCompanion.insert(
            cardId: cardId,
            periodEnd: DateTime(2026, 9, 20),
            dueDate: DateTime(2026, 10, 5),
            totalDueMinor: 1250000,
            currency: 'EGP',
          ),
        );

    final r = await ExcelExportService(db, ledger).build(paidBy: 'Tester');
    expect((r.purchases, r.payments, r.statements, r.skipped, r.foreignWithoutLocalAmount), (2, 1, 1, 1, 1));

    final a = ZipDecoder().decodeBytes(r.bytes);
    final wb = utf8.decode(a.findFile('xl/workbook.xml')!.content as List<int>);
    for (final name in [
      'Read me - اقرأني',
      'Lists',
      'Statements - الكشوف',
      'Payments - الدفعات',
      'Purchases - المشتريات',
    ]) {
      expect(wb, contains('name="$name"'));
    }
    // Lists: default nickname is "<paid by> <bank>".
    expect(sheetXml(a, 2), contains('Tester ABK'));
    // Statement: month 9, year 2026, amount 12500, due date as an Excel date.
    final st = sheetXml(a, 3);
    expect(st, contains('<c r="B3"><v>9</v></c>'));
    expect(st, contains('<c r="D3"><v>12500</v></c>'));
    expect(st, contains('<c r="E3" s="4"><v>${XlsxWorkbook.excelSerial(DateTime(2026, 10, 5))}</v></c>'));
    // Payment points at the September statement.
    final pay = sheetXml(a, 4);
    expect(pay, contains('<c r="B3"><v>9</v></c>'));
    expect(pay, contains('<c r="E3"><v>5000</v></c>'));
    expect(pay, contains('Tester'));
    // Purchases: local amount with a category; foreign one keeps the original amount and currency.
    final pur = sheetXml(a, 5);
    expect(pur, contains('<c r="E3"><v>10250.5</v></c>'));
    expect(pur, contains('<c r="I4"><v>19.99</v></c>'));
    expect(pur, contains('<t xml:space="preserve">USD</t>'));
    expect(pur, isNot(contains('<c r="E4"')));
    expect(pur, contains(r'<formula1>Lists!$B$2:$B$14</formula1>'));

    final out = Platform.environment['CG_XLSX_OUT'];
    if (out != null) File(out).writeAsBytesSync(r.bytes);
  });

  test('column names and Excel date serials', () {
    expect(XlsxWorkbook.columnName(0), 'A');
    expect(XlsxWorkbook.columnName(19), 'T');
    expect(XlsxWorkbook.columnName(26), 'AA');
    expect(XlsxWorkbook.excelSerial(DateTime(2026, 9, 15)), 46280);
  });
}
