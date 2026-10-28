import '../models.dart';
import '../money.dart';
import '../parser.dart';

/// ABK-Egypt (Al Ahli Bank of Kuwait - Egypt) credit card SMS alerts.
///
/// Known format (charge):
///   Your Credit Card#**1234 was charged EGP 1500.00 at SHOP NAME on 26/10/26
///   at 10:12. Your available limit is EGP 1125. For more info, call 19322
///
/// Only formats seen in real messages are implemented. Other ABK messages
/// (payments, refunds, declines) fall through to the review queue until a
/// real sample is added here with a golden test.
class AbkEgyptParser extends BankParser {
  const AbkEgyptParser();

  @override
  String get id => 'abk_eg_sms';

  @override
  int get version => 1;

  @override
  String get bankCode => 'ABK_EG';

  static final _charge = RegExp(
    r'Your\s+Credit\s+Card\s*#\s*\**\s*(\d{4})\s+was\s+charged\s+([A-Z]{3})\s*([\d,]+(?:\.\d+)?)\s+at\s+(.+?)\s+on\s+(\d{1,2})/(\d{1,2})/(\d{2}|\d{4})\s+at\s+(\d{1,2}):(\d{2})'
    r'(?:\.\s*Your\s+available\s+limit\s+is\s+([A-Z]{3})\s*([\d,]+(?:\.\d+)?))?',
    caseSensitive: false,
    dotAll: true,
  );

  static final _start = RegExp(r'Your\s+Credit\s+Card\s*#', caseSensitive: false);

  @override
  List<RegExp> get messageStarts => [_start];

  @override
  bool canParse(RawMessage message) => _start.hasMatch(message.body);

  @override
  ParseResult parse(RawMessage message) {
    final body = message.body.replaceAll(RegExp(r'\s+'), ' ').trim();
    final m = _charge.firstMatch(body);
    if (m == null) return const ParseNoMatch();

    final currency = m.group(2)!.toUpperCase();
    final amount = parseAmountToMinor(m.group(3)!, currency);
    if (amount == null) return const ParseNoMatch();

    final occurred = _date(m.group(5)!, m.group(6)!, m.group(7)!, m.group(8)!, m.group(9)!);
    if (occurred == null) return const ParseNoMatch();

    int? limit;
    String? limitCurrency;
    if (m.group(10) != null) {
      limitCurrency = m.group(10)!.toUpperCase();
      limit = parseAmountToMinor(m.group(11)!, limitCurrency);
    }

    return ParseSuccess(
      ParsedTransaction(
        bankCode: bankCode,
        last4: m.group(1)!,
        type: TxnType.purchase,
        amountMinor: amount,
        currency: currency,
        merchant: m.group(4)!.trim(),
        occurredAt: occurred,
        availableLimitMinor: limit,
        availableLimitCurrency: limitCurrency,
        parserId: id,
        parserVersion: version,
      ),
    );
  }

  /// Dates are printed day-first: dd/MM/yy.
  static DateTime? _date(String d, String mo, String y, String h, String mi) {
    final day = int.parse(d);
    final month = int.parse(mo);
    var year = int.parse(y);
    if (y.length == 2) year += 2000;
    final hour = int.parse(h);
    final minute = int.parse(mi);
    if (month < 1 || month > 12 || day < 1 || day > 31 || hour > 23 || minute > 59) return null;
    final dt = DateTime(year, month, day, hour, minute);
    if (dt.month != month || dt.day != day) return null; // e.g. 31/02
    return dt;
  }
}
