import 'package:cg_core/cg_core.dart';
import 'package:test/test.dart';

RawMessage _m(SourceType s, String? sender, [String body = 'Your Credit Card#**1234 was charged']) =>
    RawMessage(sourceType: s, sender: sender, body: body, receivedAt: DateTime(2026));

void main() {
  const gate = IngestionGate([
    SenderRule(address: 'ABK-Egypt', bankCode: 'ABK_EG', mustContain: 'Credit Card#'),
    SenderRule(address: 'CIB', bankCode: 'CIB_EG', mode: SenderMode.review),
    SenderRule(address: 'NBE', bankCode: 'NBE_EG', enabled: false),
  ]);

  test('allowed sender in auto mode is parsed', () {
    final d = gate.decide(_m(SourceType.sms, 'ABK-Egypt'));
    expect(d.action, GateAction.parse);
    expect(d.bankCode, 'ABK_EG');
  });

  test('sender matching ignores case, spaces and dashes', () {
    expect(gate.decide(_m(SourceType.notification, 'abk egypt')).action, GateAction.parse);
  });

  test('text filter drops OTP from an allowed sender', () {
    final d = gate.decide(_m(SourceType.sms, 'ABK-Egypt', 'Your OTP is 1234'));
    expect(d.action, GateAction.ignore);
  });

  test('review mode holds messages', () {
    expect(gate.decide(_m(SourceType.sms, 'CIB')).action, GateAction.review);
  });

  test('unknown and disabled senders are ignored', () {
    expect(gate.decide(_m(SourceType.sms, 'Vodafone')).action, GateAction.ignore);
    expect(gate.decide(_m(SourceType.sms, 'NBE')).action, GateAction.ignore);
  });

  test('user-picked sources are always allowed', () {
    expect(gate.decide(_m(SourceType.paste, null)).action, GateAction.parse);
  });

  test('shortcut without sender relies on detected bank', () {
    expect(gate.decide(_m(SourceType.shortcut, null), detectedBankCode: 'ABK_EG').action, GateAction.parse);
    expect(gate.decide(_m(SourceType.shortcut, null)).action, GateAction.review);
  });
}
