import 'package:cg_core/cg_core.dart';
import 'package:test/test.dart';

/// Synthetic messages in ABK-Egypt's real format. Card digits, amounts and
/// merchants are made up; never commit real messages.
const _charge1 =
    'Your Credit Card#**1234 was charged EGP 1500.00 at FawryPF*Test Shop on 26/10/26 at 10:12. Your available limit is EGP 18500. For more info, call 19322';
const _charge2 =
    'Your Credit Card#**1234 was charged EGP 249.99 at Google One Mou on 27/10/26 at 02:55. Your available limit is EGP 18250. For more info, call 19322';
const _charge3 =
    'Your Credit Card#**1234 was charged EGP 1,449.50 at GOOGLE*GOOGLE on 28/10/26 at 17:05. Your available limit is EGP 16,800.50. For more info, call 19322';
const _usd =
    'Your Credit Card#**5678 was charged USD 12.00 at NETFLIX.COM on 01/11/26 at 00:01. Your available limit is EGP 900. For more info, call 19322';

RawMessage _sms(String body) =>
    RawMessage(sourceType: SourceType.sms, sender: 'ABK-Egypt', body: body, receivedAt: DateTime(2026, 10, 28));

ParsedTransaction _ok(String body) {
  final r = const AbkEgyptParser().parse(_sms(body));
  expect(r, isA<ParseSuccess>(), reason: body);
  return (r as ParseSuccess).transaction;
}

void main() {
  group('AbkEgyptParser charge', () {
    test('extracts every field', () {
      final t = _ok(_charge1);
      expect(t.bankCode, 'ABK_EG');
      expect(t.last4, '1234');
      expect(t.type, TxnType.purchase);
      expect(t.amountMinor, 150000);
      expect(t.currency, 'EGP');
      expect(t.merchant, 'FawryPF*Test Shop');
      expect(t.occurredAt, DateTime(2026, 10, 26, 10, 12));
      expect(t.availableLimitMinor, 1850000);
      expect(t.availableLimitCurrency, 'EGP');
      expect(t.parserId, 'abk_eg_sms');
    });

    test('decimals and early-morning time', () {
      final t = _ok(_charge2);
      expect(t.amountMinor, 24999);
      expect(t.merchant, 'Google One Mou');
      expect(t.occurredAt, DateTime(2026, 10, 27, 2, 55));
    });

    test('thousands separators in amount and limit', () {
      final t = _ok(_charge3);
      expect(t.amountMinor, 144950);
      expect(t.availableLimitMinor, 1680050);
      expect(t.merchant, 'GOOGLE*GOOGLE');
    });

    test('foreign currency keeps its own currency', () {
      final t = _ok(_usd);
      expect(t.currency, 'USD');
      expect(t.amountMinor, 1200);
      expect(t.availableLimitCurrency, 'EGP');
      expect(t.availableLimitMinor, 90000);
    });

    test('line breaks inside the message', () {
      final t = _ok(_charge1.replaceAll(' at ', '\nat '));
      expect(t.amountMinor, 150000);
      expect(t.merchant, 'FawryPF*Test Shop');
    });

    test('works without the available-limit sentence', () {
      final t = _ok('Your Credit Card#**1234 was charged EGP 10.00 at SHOP on 05/01/27 at 09:00.');
      expect(t.availableLimitMinor, isNull);
      expect(t.occurredAt, DateTime(2027, 1, 5, 9, 0));
    });

    test('merchant containing " on " is kept whole', () {
      final t = _ok('Your Credit Card#**1234 was charged EGP 10.00 at CAFE ON NILE on 05/01/27 at 09:00.');
      expect(t.merchant, 'CAFE ON NILE');
    });

    test('rejects impossible dates', () {
      final r = const AbkEgyptParser().parse(
        _sms('Your Credit Card#**1234 was charged EGP 10.00 at SHOP on 31/02/27 at 09:00.'),
      );
      expect(r, isA<ParseNoMatch>());
    });

    test('unknown ABK formats are not guessed', () {
      final r = const AbkEgyptParser().parse(_sms('Your Credit Card#**1234 payment of EGP 500 was received.'));
      expect(r, isA<ParseNoMatch>());
    });

    test('canParse ignores unrelated messages', () {
      expect(const AbkEgyptParser().canParse(_sms('Your OTP is 123456')), isFalse);
    });
  });

  group('ParserRegistry', () {
    test('routes to ABK and filters by bank', () {
      final reg = ParserRegistry.defaults();
      expect(reg.parse(_sms(_charge1)), isA<ParseSuccess>());
      expect(reg.parse(_sms(_charge1), bankCode: 'CIB_EG'), isA<ParseNoMatch>());
    });
  });

  group('transactionHash', () {
    test('same alert from different sources collides', () {
      final a = _ok(_charge1);
      final b =
          (const AbkEgyptParser().parse(
                    RawMessage(
                      sourceType: SourceType.paste,
                      body: _charge1.replaceAll('  ', ' '),
                      receivedAt: DateTime(2027),
                    ),
                  )
                  as ParseSuccess)
              .transaction;
      expect(transactionHash(a), transactionHash(b));
    });

    test('different amount differs', () {
      expect(transactionHash(_ok(_charge1)), isNot(transactionHash(_ok(_charge2))));
    });
  });

  group('splitMessages', () {
    test('splits a pasted conversation with and without blank lines', () {
      final text = '$_charge1\n$_charge2\n\nYesterday 9:46 AM\n\n$_charge3';
      final parts = splitMessages(text, starts: ParserRegistry.defaults().messageStarts);
      expect(parts, [_charge1, _charge2, 'Yesterday 9:46 AM', _charge3]);
    });
  });
}
