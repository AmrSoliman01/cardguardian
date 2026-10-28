import 'package:cardguardian/services/key_store.dart';
import 'package:cardguardian/services/pin_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late PinService pins;
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    now = DateTime(2026, 10, 28, 12);
    pins = PinService(KeyStore(), clock: () => now);
  });

  test('database key is stable and 64 hex chars', () async {
    final keys = KeyStore();
    final a = await keys.databaseKey();
    expect(a, matches(RegExp(r'^[0-9a-f]{64}$')));
    expect(await keys.databaseKey(), a);
  });

  test('set and verify PIN', () async {
    final sw = Stopwatch()..start();
    await pins.setPin('482913');
    // ignore: avoid_print
    print('Argon2id set: ${sw.elapsedMilliseconds} ms');
    expect(await pins.hasPin(), isTrue);
    expect(await pins.verify('482913'), isA<PinOk>());
    final wrong = await pins.verify('000000');
    expect(wrong, isA<PinWrong>());
    expect((wrong as PinWrong).attemptsLeft, 4);
  });

  test('locks out after 5 failures, then escalates', () async {
    await pins.setPin('1111');
    for (var i = 0; i < 4; i++) {
      expect(await pins.verify('2222'), isA<PinWrong>());
    }
    final locked = await pins.verify('2222');
    expect(locked, isA<PinLockedOut>());
    expect((locked as PinLockedOut).until, now.add(const Duration(seconds: 30)));
    // Even the right PIN is refused while locked.
    expect(await pins.verify('1111'), isA<PinLockedOut>());

    now = now.add(const Duration(seconds: 31));
    for (var i = 0; i < 4; i++) {
      await pins.verify('2222');
    }
    final again = await pins.verify('2222') as PinLockedOut;
    expect(again.until, now.add(const Duration(seconds: 60)));

    now = now.add(const Duration(minutes: 2));
    expect(await pins.verify('1111'), isA<PinOk>());
  });
}
