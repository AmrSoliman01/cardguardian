import 'models.dart';
import 'money.dart';

/// Minimal RFC 4180 CSV reader: quoted fields, escaped quotes, CRLF/LF.
List<List<String>> parseCsv(String input, {String delimiter = ','}) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var inQuotes = false;
  var i = 0;
  final text = input.startsWith('﻿') ? input.substring(1) : input;
  while (i < text.length) {
    final c = text[i];
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i += 2;
          continue;
        }
        inQuotes = false;
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      inQuotes = true;
    } else if (c == delimiter) {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n' || c == '\r') {
      row.add(field.toString());
      field.clear();
      if (row.any((f) => f.trim().isNotEmpty)) rows.add(row);
      row = <String>[];
      if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
    } else {
      field.write(c);
    }
    i++;
  }
  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    if (row.any((f) => f.trim().isNotEmpty)) rows.add(row);
  }
  return rows;
}

enum CsvDateFormat {
  dmy('dd/MM/yyyy'),
  mdy('MM/dd/yyyy'),
  ymd('yyyy-MM-dd');

  const CsvDateFormat(this.label);
  final String label;
}

/// How the columns of a bank's CSV export map to transaction fields.
class CsvMapping {
  const CsvMapping({
    required this.dateColumn,
    required this.amountColumn,
    required this.merchantColumn,
    this.dateFormat = CsvDateFormat.dmy,
    this.currencyColumn,
    this.defaultCurrency = 'EGP',
    this.hasHeader = true,
    this.negativeIsSpend = false,
  });

  final int dateColumn;
  final int amountColumn;
  final int merchantColumn;
  final CsvDateFormat dateFormat;
  final int? currencyColumn;
  final String defaultCurrency;
  final bool hasHeader;

  /// Some exports show purchases as negative numbers. When true, negative
  /// amounts are purchases and positive ones are refunds/payments.
  final bool negativeIsSpend;
}

class CsvRowError {
  const CsvRowError(this.rowIndex, this.message);
  final int rowIndex;
  final String message;
}

class CsvImportResult {
  const CsvImportResult(this.transactions, this.errors);
  final List<ParsedTransaction> transactions;
  final List<CsvRowError> errors;
}

DateTime? parseCsvDate(String s, CsvDateFormat f) {
  final m = RegExp(r'^(\d{1,4})[/\-.](\d{1,2})[/\-.](\d{1,4})(?:[ T](\d{1,2}):(\d{2}))?').firstMatch(s.trim());
  if (m == null) return null;
  int a = int.parse(m.group(1)!), b = int.parse(m.group(2)!), c = int.parse(m.group(3)!);
  int y, mo, d;
  switch (f) {
    case CsvDateFormat.dmy:
      d = a;
      mo = b;
      y = c;
    case CsvDateFormat.mdy:
      mo = a;
      d = b;
      y = c;
    case CsvDateFormat.ymd:
      y = a;
      mo = b;
      d = c;
  }
  if (y < 100) y += 2000;
  final h = m.group(4) == null ? 0 : int.parse(m.group(4)!);
  final mi = m.group(5) == null ? 0 : int.parse(m.group(5)!);
  if (mo < 1 || mo > 12 || d < 1 || d > 31 || h > 23 || mi > 59) return null;
  final dt = DateTime(y, mo, d, h, mi);
  if (dt.month != mo || dt.day != d) return null;
  return dt;
}

/// Converts CSV rows into transactions for one card.
CsvImportResult importCsv(
  List<List<String>> rows,
  CsvMapping mapping, {
  required String bankCode,
  required String last4,
}) {
  final out = <ParsedTransaction>[];
  final errors = <CsvRowError>[];
  for (var i = mapping.hasHeader ? 1 : 0; i < rows.length; i++) {
    final r = rows[i];
    String cell(int idx) => idx < r.length ? r[idx].trim() : '';
    final date = parseCsvDate(cell(mapping.dateColumn), mapping.dateFormat);
    if (date == null) {
      errors.add(CsvRowError(i, 'date'));
      continue;
    }
    final currency = (mapping.currencyColumn != null ? cell(mapping.currencyColumn!) : '').toUpperCase();
    final cur = RegExp(r'^[A-Z]{3}$').hasMatch(currency) ? currency : mapping.defaultCurrency;
    var rawAmount = cell(mapping.amountColumn).replaceAll(RegExp(r'[^\d.,\-()]'), '');
    var negative = false;
    if (rawAmount.startsWith('-')) {
      negative = true;
      rawAmount = rawAmount.substring(1);
    } else if (rawAmount.startsWith('(') && rawAmount.endsWith(')')) {
      negative = true;
      rawAmount = rawAmount.substring(1, rawAmount.length - 1);
    }
    final minor = parseAmountToMinor(rawAmount, cur);
    if (minor == null || minor == 0) {
      errors.add(CsvRowError(i, 'amount'));
      continue;
    }
    final isSpend = mapping.negativeIsSpend ? negative : !negative;
    out.add(
      ParsedTransaction(
        bankCode: bankCode,
        last4: last4,
        type: isSpend ? TxnType.purchase : TxnType.refund,
        amountMinor: minor,
        currency: cur,
        merchant: cell(mapping.merchantColumn),
        occurredAt: date,
        parserId: 'csv',
        parserVersion: 1,
      ),
    );
  }
  return CsvImportResult(out, errors);
}
