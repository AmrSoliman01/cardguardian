import 'package:cg_core/cg_core.dart';
import 'package:test/test.dart';

void main() {
  test('parseAmountToMinor', () {
    expect(parseAmountToMinor('97800.00', 'EGP'), 9780000);
    expect(parseAmountToMinor('97,800.00', 'EGP'), 9780000);
    expect(parseAmountToMinor('1125', 'EGP'), 112500);
    expect(parseAmountToMinor('0.5', 'EGP'), 50);
    expect(parseAmountToMinor('1.250', 'KWD'), 1250);
    expect(parseAmountToMinor('100', 'JPY'), 100);
    expect(parseAmountToMinor('10.000', 'EGP'), 1000);
    expect(parseAmountToMinor('10.001', 'EGP'), isNull);
    expect(parseAmountToMinor('1,25', 'EGP'), isNull);
    expect(parseAmountToMinor('abc', 'EGP'), isNull);
  });

  test('formatMinor and Money', () {
    expect(formatMinor(9780000, 'EGP'), '97800.00');
    expect(formatMinor(5, 'EGP'), '0.05');
    expect(formatMinor(-1250, 'KWD'), '-1.250');
    expect((const Money(100, 'EGP') + const Money(250, 'EGP')).minor, 350);
    expect(() => const Money(1, 'EGP') + const Money(1, 'USD'), throwsArgumentError);
  });

  test('spendSign', () {
    expect(TxnType.purchase.spendSign, 1);
    expect(TxnType.refund.spendSign, -1);
    expect(TxnType.payment.spendSign, 0);
    expect(TxnType.declined.spendSign, 0);
  });
}
