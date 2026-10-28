/// Where a message or record came from.
enum SourceType {
  sms,
  notification,
  shortcut,
  share,
  paste,
  csv,
  manual;

  static SourceType fromName(String name) =>
      SourceType.values.firstWhere((e) => e.name == name, orElse: () => SourceType.manual);
}

/// The kinds of card movements we track.
enum TxnType {
  purchase,
  refund,
  payment,
  fee,
  interest,
  cashWithdrawal,
  installment,
  reversal,
  declined;

  static TxnType fromName(String name) =>
      TxnType.values.firstWhere((e) => e.name == name, orElse: () => TxnType.purchase);

  /// Sign of this type's effect on spending: +1 adds to spend, -1 reduces it,
  /// 0 does not count (payments move debt, declined never happened).
  int get spendSign => switch (this) {
    TxnType.purchase || TxnType.fee || TxnType.interest || TxnType.cashWithdrawal || TxnType.installment => 1,
    TxnType.refund || TxnType.reversal => -1,
    TxnType.payment || TxnType.declined => 0,
  };
}

/// A message as received from any source, before parsing.
class RawMessage {
  const RawMessage({required this.sourceType, required this.body, required this.receivedAt, this.sender});

  final SourceType sourceType;
  final String? sender;
  final String body;
  final DateTime receivedAt;

  @override
  String toString() => 'RawMessage(${sourceType.name}, $sender, ${body.length} chars)';
}

/// A transaction extracted from a message, CSV row or manual entry.
class ParsedTransaction {
  const ParsedTransaction({
    required this.bankCode,
    required this.last4,
    required this.type,
    required this.amountMinor,
    required this.currency,
    required this.merchant,
    required this.occurredAt,
    required this.parserId,
    required this.parserVersion,
    this.availableLimitMinor,
    this.availableLimitCurrency,
    this.originalAmountMinor,
    this.originalCurrency,
  });

  final String bankCode;
  final String last4;
  final TxnType type;

  /// Always positive; the [type] carries the direction.
  final int amountMinor;
  final String currency;
  final String merchant;

  /// Wall-clock time printed in the message, as a local (non-UTC) DateTime.
  final DateTime occurredAt;
  final int? availableLimitMinor;
  final String? availableLimitCurrency;
  final int? originalAmountMinor;
  final String? originalCurrency;
  final String parserId;
  final int parserVersion;

  ParsedTransaction copyWith({
    String? bankCode,
    String? last4,
    TxnType? type,
    int? amountMinor,
    String? currency,
    String? merchant,
    DateTime? occurredAt,
  }) => ParsedTransaction(
    bankCode: bankCode ?? this.bankCode,
    last4: last4 ?? this.last4,
    type: type ?? this.type,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    merchant: merchant ?? this.merchant,
    occurredAt: occurredAt ?? this.occurredAt,
    availableLimitMinor: availableLimitMinor,
    availableLimitCurrency: availableLimitCurrency,
    originalAmountMinor: originalAmountMinor,
    originalCurrency: originalCurrency,
    parserId: parserId,
    parserVersion: parserVersion,
  );

  @override
  String toString() =>
      'ParsedTransaction($bankCode *$last4 ${type.name} $currency $amountMinor @ $merchant $occurredAt)';
}

sealed class ParseResult {
  const ParseResult();
}

class ParseSuccess extends ParseResult {
  const ParseSuccess(this.transaction);
  final ParsedTransaction transaction;
}

/// The message belongs to a known bank but is not a transaction (OTP, promo).
class ParseIgnored extends ParseResult {
  const ParseIgnored(this.reason);
  final String reason;
}

/// No parser understood the message. It goes to the review queue.
class ParseNoMatch extends ParseResult {
  const ParseNoMatch();
}
