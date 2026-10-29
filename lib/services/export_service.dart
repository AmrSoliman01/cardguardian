import 'package:cg_core/cg_core.dart';

import '../data/repos/ledger_repo.dart';

/// Builds a CSV of transactions. Amounts are plain decimals, dates ISO 8601.
class ExportService {
  ExportService(this.ledger);
  final LedgerRepo ledger;

  Future<String> transactionsCsv({DateTime? from, DateTime? to, int? cardId}) async {
    final rows = await ledger.watchTransactions(TxnFilter(from: from, to: to, cardId: cardId, limit: 1000000)).first;
    final b = StringBuffer('date,bank,card,type,amount,currency,merchant,category,note\r\n');
    for (final v in rows) {
      final t = v.txn;
      b.write(
        [
          t.occurredAt.toIso8601String(),
          v.card.bankCode,
          v.card.last4,
          t.type,
          formatMinor(t.amountMinor, t.currency),
          t.currency,
          t.merchant,
          v.category?.nameEn ?? '',
          t.note ?? '',
        ].map(_csvField).join(','),
      );
      b.write('\r\n');
    }
    return b.toString();
  }

  static String _csvField(String s) {
    // Neutralise spreadsheet formulas and quote when needed.
    var v = s;
    if (v.isNotEmpty && '=+-@'.contains(v[0]) && double.tryParse(v) == null) v = "'$v";
    if (v.contains(RegExp(r'[",\r\n]'))) v = '"${v.replaceAll('"', '""')}"';
    return v;
  }
}
