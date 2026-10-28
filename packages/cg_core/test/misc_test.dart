import 'package:cg_core/cg_core.dart';
import 'package:test/test.dart';

void main() {
  test('categorize prefers user rules then the longest default', () {
    expect(categorize('GOOGLE*YOUTUBE'), CategoryKeys.subscriptions);
    expect(categorize('Talabat Egypt'), CategoryKeys.dining);
    expect(categorize('Unknown merchant'), isNull);
    expect(
      categorize('GOOGLE*ADS', userRules: const [MerchantRule('google*ads', CategoryKeys.bills)]),
      CategoryKeys.bills,
    );
  });

  group('CSV', () {
    test('parses quoted fields and BOM', () {
      final rows = parseCsv('﻿Date,Desc,Amount\r\n01/10/2026,"Shop, Ltd","1,200.50"\n');
      expect(rows, [
        ['Date', 'Desc', 'Amount'],
        ['01/10/2026', 'Shop, Ltd', '1,200.50'],
      ]);
    });

    test('maps rows to transactions with refunds and errors', () {
      final rows = parseCsv('Date,Desc,Amount\n01/10/2026,Shop,-100.00\n02/10/2026,Refund,25\nbad,X,1\n');
      final r = importCsv(
        rows,
        const CsvMapping(dateColumn: 0, merchantColumn: 1, amountColumn: 2, negativeIsSpend: true),
        bankCode: 'ABK_EG',
        last4: '1234',
      );
      expect(r.transactions.length, 2);
      expect(r.transactions[0].type, TxnType.purchase);
      expect(r.transactions[0].amountMinor, 10000);
      expect(r.transactions[1].type, TxnType.refund);
      expect(r.errors.single.rowIndex, 3);
    });

    test('date formats', () {
      expect(parseCsvDate('2026-10-01', CsvDateFormat.ymd), DateTime(2026, 10, 1));
      expect(parseCsvDate('10/01/2026', CsvDateFormat.mdy), DateTime(2026, 10, 1));
      expect(parseCsvDate('31/02/2026', CsvDateFormat.dmy), isNull);
    });
  });
}
