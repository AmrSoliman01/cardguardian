import 'banks/abk_egypt.dart';
import 'models.dart';

/// A bank known to the app.
class BankInfo {
  const BankInfo({
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.country,
    this.defaultSenders = const [],
  });

  final String code;
  final String nameEn;
  final String nameAr;
  final String country;

  /// Sender IDs this bank usually uses for SMS. Suggestions only: the user
  /// decides which senders the app may read.
  final List<String> defaultSenders;
}

const List<BankInfo> knownBanks = [
  BankInfo(
    code: 'ABK_EG',
    nameEn: 'ABK-Egypt',
    nameAr: 'البنك الأهلي الكويتي - مصر',
    country: 'EG',
    defaultSenders: ['ABK-Egypt'],
  ),
  BankInfo(code: 'CIB_EG', nameEn: 'CIB', nameAr: 'البنك التجاري الدولي', country: 'EG', defaultSenders: ['CIB']),
  BankInfo(
    code: 'NBE_EG',
    nameEn: 'National Bank of Egypt',
    nameAr: 'البنك الأهلي المصري',
    country: 'EG',
    defaultSenders: ['NBE'],
  ),
  BankInfo(
    code: 'BM_EG',
    nameEn: 'Banque Misr',
    nameAr: 'بنك مصر',
    country: 'EG',
    defaultSenders: ['Banque Misr', 'BanqueMisr'],
  ),
  BankInfo(code: 'QNB_EG', nameEn: 'QNB Egypt', nameAr: 'بنك QNB مصر', country: 'EG', defaultSenders: ['QNB']),
  BankInfo(code: 'OTHER', nameEn: 'Other bank', nameAr: 'بنك آخر', country: ''),
];

BankInfo? bankByCode(String code) {
  for (final b in knownBanks) {
    if (b.code == code) return b;
  }
  return null;
}

/// Rule-based parser for one bank's message formats.
abstract class BankParser {
  const BankParser();

  /// Stable identifier stored with every transaction (e.g. `abk_eg_sms`).
  String get id;

  /// Bumped whenever extraction rules change.
  int get version;

  String get bankCode;

  /// Cheap pre-check before running the full regexes.
  bool canParse(RawMessage message);

  ParseResult parse(RawMessage message);

  /// Regexes marking where one message starts, used to split pasted text that
  /// contains several messages without blank lines between them.
  List<RegExp> get messageStarts => const [];
}

/// Picks the right parser for a message.
class ParserRegistry {
  ParserRegistry(this.parsers);

  factory ParserRegistry.defaults() => ParserRegistry([const AbkEgyptParser()]);

  final List<BankParser> parsers;

  Iterable<String> get supportedBankCodes => parsers.map((p) => p.bankCode).toSet();

  /// Parses [message]. When [bankCode] is given only that bank's parsers run.
  ParseResult parse(RawMessage message, {String? bankCode}) {
    ParseResult? ignored;
    for (final p in parsers) {
      if (bankCode != null && p.bankCode != bankCode) continue;
      if (!p.canParse(message)) continue;
      final r = p.parse(message);
      if (r is ParseSuccess) return r;
      if (r is ParseIgnored) ignored ??= r;
    }
    return ignored ?? const ParseNoMatch();
  }

  List<RegExp> get messageStarts => [for (final p in parsers) ...p.messageStarts];
}
