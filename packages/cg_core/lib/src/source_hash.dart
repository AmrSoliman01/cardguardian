import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'models.dart';

/// Stable identity of a transaction, used as a UNIQUE key so the same alert
/// arriving twice (SMS + notification, or a re-pasted history) is stored once.
///
/// Built from the parsed fields, not the raw text, so different sources of
/// the same alert collide on purpose. Minute precision matches the messages.
String transactionHash(ParsedTransaction t) {
  final o = t.occurredAt;
  String two(int v) => v.toString().padLeft(2, '0');
  final when = '${o.year}-${two(o.month)}-${two(o.day)}T${two(o.hour)}:${two(o.minute)}';
  final key = [
    t.bankCode,
    t.last4,
    t.type.name,
    t.amountMinor,
    t.currency.toUpperCase(),
    normalizeMerchant(t.merchant),
    when,
  ].join('|');
  return sha256.convert(utf8.encode(key)).toString();
}

/// Identity of a raw message, to avoid queueing the same text twice.
String rawMessageHash(RawMessage m) {
  final body = m.body.replaceAll(RegExp(r'\s+'), ' ').trim();
  final sender = normalizeSender(m.sender ?? '');
  return sha256.convert(utf8.encode('$sender|$body')).toString();
}

String normalizeMerchant(String merchant) => merchant.toUpperCase().replaceAll(RegExp(r'\s+'), ' ').trim();

/// Sender IDs differ by case, spaces and dashes between sources
/// ("ABK-Egypt" in SMS, "ABK Egypt" as a notification title).
String normalizeSender(String sender) => sender.toLowerCase().replaceAll(RegExp(r'[^a-z0-9؀-ۿ+]'), '');
