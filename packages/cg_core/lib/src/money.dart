/// Money is always an integer number of minor units (piasters, cents, fils)
/// plus an ISO 4217 currency code. Floating point is never used for money.
library;

/// Number of decimal places for currencies we expect to see. Anything not
/// listed uses 2, which is the ISO default for most currencies.
const Map<String, int> _exponents = {
  'BHD': 3,
  'IQD': 3,
  'JOD': 3,
  'KWD': 3,
  'LYD': 3,
  'OMR': 3,
  'TND': 3,
  'JPY': 0,
  'KRW': 0,
  'VND': 0,
  'CLP': 0,
  'ISK': 0,
};

int currencyExponent(String currency) => _exponents[currency.toUpperCase()] ?? 2;

class Money implements Comparable<Money> {
  const Money(this.minor, this.currency);

  final int minor;
  final String currency;

  static Money zero(String currency) => Money(0, currency);

  Money operator +(Money other) {
    _checkSame(other);
    return Money(minor + other.minor, currency);
  }

  Money operator -(Money other) {
    _checkSame(other);
    return Money(minor - other.minor, currency);
  }

  Money operator -() => Money(-minor, currency);

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;

  /// Decimal string without grouping, e.g. `97800.00`. Exact, no doubles.
  String toDecimalString() => formatMinor(minor, currency);

  void _checkSame(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Currency mismatch: $currency vs ${other.currency}');
    }
  }

  @override
  int compareTo(Money other) {
    _checkSame(other);
    return minor.compareTo(other.minor);
  }

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => '$currency ${toDecimalString()}';
}

/// Formats [minor] units as a plain decimal string, e.g. 9780000 EGP -> "97800.00".
String formatMinor(int minor, String currency) {
  final exp = currencyExponent(currency);
  final negative = minor < 0;
  final digits = minor.abs().toString();
  if (exp == 0) return '${negative ? '-' : ''}$digits';
  final padded = digits.padLeft(exp + 1, '0');
  final whole = padded.substring(0, padded.length - exp);
  final frac = padded.substring(padded.length - exp);
  return '${negative ? '-' : ''}$whole.$frac';
}

/// Parses a decimal amount as printed in bank messages into minor units.
///
/// Accepts `97800.00`, `97,800.00`, `1125`, `1,125`, `0.5`. Thousands
/// separators must be commas; the decimal separator must be a dot. Returns
/// null when the text is not a valid amount or has more decimals than the
/// currency allows.
int? parseAmountToMinor(String text, String currency) {
  final t = text.trim();
  final match = RegExp(r'^(\d{1,3}(?:,\d{3})+|\d+)(?:\.(\d+))?$').firstMatch(t);
  if (match == null) return null;
  final whole = match.group(1)!.replaceAll(',', '');
  var frac = match.group(2) ?? '';
  final exp = currencyExponent(currency);
  if (frac.length > exp) {
    // Allow trailing zeros beyond the exponent (e.g. "10.000" for a 2-dp currency).
    final extra = frac.substring(exp);
    if (extra.replaceAll('0', '').isNotEmpty) return null;
    frac = frac.substring(0, exp);
  }
  frac = frac.padRight(exp, '0');
  final value = BigInt.parse(whole) * BigInt.from(10).pow(exp) + (exp == 0 ? BigInt.zero : BigInt.parse(frac));
  if (value > BigInt.from(0x1FFFFFFFFFFFFF)) return null; // keep within JS-safe/SQLite range
  return value.toInt();
}
