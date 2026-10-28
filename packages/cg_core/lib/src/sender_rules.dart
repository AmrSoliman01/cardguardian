import 'models.dart';
import 'source_hash.dart';

/// What to do with new messages from an allowed sender.
enum SenderMode {
  /// Parse and add transactions automatically.
  auto,

  /// Hold every message in the review queue until the user approves it.
  review;

  static SenderMode fromName(String name) =>
      SenderMode.values.firstWhere((e) => e.name == name, orElse: () => SenderMode.review);
}

/// A sender the user allowed the app to read. Messages from any other sender
/// are dropped before anything is stored.
class SenderRule {
  const SenderRule({
    required this.address,
    required this.bankCode,
    this.enabled = true,
    this.mode = SenderMode.auto,
    this.mustContain,
  });

  /// Sender ID as shown on the phone, e.g. `ABK-Egypt`.
  final String address;
  final String bankCode;
  final bool enabled;
  final SenderMode mode;

  /// Optional extra filter: only messages containing this text are read
  /// (e.g. `Credit Card#` to skip OTP and promotional messages).
  final String? mustContain;

  bool matchesSender(String sender) => normalizeSender(sender) == normalizeSender(address);

  bool matchesBody(String body) {
    final f = mustContain?.trim();
    if (f == null || f.isEmpty) return true;
    return body.toLowerCase().contains(f.toLowerCase());
  }
}

enum GateAction { ignore, review, parse }

class GateDecision {
  const GateDecision(this.action, {this.bankCode, this.reason});
  final GateAction action;
  final String? bankCode;
  final String? reason;

  @override
  String toString() => 'GateDecision(${action.name}, $bankCode, $reason)';
}

/// Decides whether an incoming message may be read at all, and how.
///
/// Automatic sources (SMS, notifications, Shortcuts) are filtered by the
/// user's sender rules. Sources where the user hand-picked the text (paste,
/// share, CSV, manual) are always allowed.
class IngestionGate {
  const IngestionGate(this.rules);

  final List<SenderRule> rules;

  Iterable<SenderRule> get _enabled => rules.where((r) => r.enabled);

  /// [detectedBankCode] is the bank a parser recognised in the body, used
  /// when the source gives no sender (a Shortcut without the Sender field).
  GateDecision decide(RawMessage message, {String? detectedBankCode}) {
    switch (message.sourceType) {
      case SourceType.paste:
      case SourceType.share:
      case SourceType.csv:
      case SourceType.manual:
        return GateDecision(GateAction.parse, bankCode: detectedBankCode, reason: 'user-selected');
      case SourceType.sms:
      case SourceType.notification:
      case SourceType.shortcut:
        break;
    }

    final sender = message.sender?.trim() ?? '';
    if (sender.isNotEmpty) {
      for (final r in _enabled) {
        if (!r.matchesSender(sender)) continue;
        if (!r.matchesBody(message.body)) {
          return const GateDecision(GateAction.ignore, reason: 'filtered-by-text');
        }
        return GateDecision(r.mode == SenderMode.auto ? GateAction.parse : GateAction.review, bankCode: r.bankCode);
      }
      return const GateDecision(GateAction.ignore, reason: 'sender-not-allowed');
    }

    // No sender: only Shortcuts can deliver this. Trust the bank the parser
    // recognised if the user enabled that bank; otherwise ask the user.
    if (detectedBankCode != null) {
      for (final r in _enabled) {
        if (r.bankCode == detectedBankCode && r.matchesBody(message.body)) {
          return GateDecision(r.mode == SenderMode.auto ? GateAction.parse : GateAction.review, bankCode: r.bankCode);
        }
      }
    }
    return GateDecision(GateAction.review, bankCode: detectedBankCode, reason: 'no-sender');
  }
}
