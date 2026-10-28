import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'key_store.dart';

/// Argon2id parameters. Pure-Dart Argon2 is slower than native, so memory is
/// modest; the lockout below is what really stops guessing.
class KdfParams {
  const KdfParams({this.memoryKiB = 8192, this.iterations = 3, this.parallelism = 1});
  final int memoryKiB;
  final int iterations;
  final int parallelism;

  Map<String, Object?> toJson() => {'m': memoryKiB, 't': iterations, 'p': parallelism};
  factory KdfParams.fromJson(Map<String, Object?> j) =>
      KdfParams(memoryKiB: j['m']! as int, iterations: j['t']! as int, parallelism: j['p']! as int);
}

/// Derives a 32-byte key from [secret] with Argon2id, off the UI isolate.
Future<List<int>> deriveKey(String secret, List<int> salt, KdfParams p) {
  return Isolate.run(() async {
    final algo = Argon2id(parallelism: p.parallelism, memory: p.memoryKiB, iterations: p.iterations, hashLength: 32);
    final key = await algo.deriveKey(secretKey: SecretKey(utf8.encode(secret)), nonce: salt);
    return key.extractBytes();
  });
}

List<int> randomBytes(int n) {
  final r = Random.secure();
  return List<int>.generate(n, (_) => r.nextInt(256));
}

bool constantTimeEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

sealed class PinCheck {
  const PinCheck();
}

class PinOk extends PinCheck {
  const PinOk();
}

class PinWrong extends PinCheck {
  const PinWrong(this.attemptsLeft);
  final int attemptsLeft;
}

class PinLockedOut extends PinCheck {
  const PinLockedOut(this.until);
  final DateTime until;
}

/// App PIN stored as an Argon2id hash in the Keychain/Keystore, with an
/// escalating lockout after repeated failures.
class PinService {
  PinService(this.keys, {this.params = const KdfParams(), DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  final KeyStore keys;
  final KdfParams params;
  final DateTime Function() _now;

  static const maxAttempts = 5;

  Future<bool> hasPin() async => (await keys.readPinRecord()) != null;

  Future<void> setPin(String pin) async {
    final salt = randomBytes(16);
    final hash = await deriveKey(pin, salt, params);
    await keys.writePinRecord({'v': 1, 'salt': base64Encode(salt), 'hash': base64Encode(hash), 'kdf': params.toJson()});
    await keys.writeFailures({});
  }

  Future<PinCheck> verify(String pin) async {
    final fails = await keys.readFailures();
    final lockedUntil = fails['until'] == null ? null : DateTime.fromMillisecondsSinceEpoch(fails['until']! as int);
    if (lockedUntil != null && _now().isBefore(lockedUntil)) return PinLockedOut(lockedUntil);

    final rec = await keys.readPinRecord();
    if (rec == null) return const PinWrong(0);
    final salt = base64Decode(rec['salt']! as String);
    final expected = base64Decode(rec['hash']! as String);
    final p = KdfParams.fromJson((rec['kdf']! as Map).cast<String, Object?>());
    final actual = await deriveKey(pin, salt, p);
    if (constantTimeEquals(actual, expected)) {
      await keys.writeFailures({});
      return const PinOk();
    }

    final count = ((fails['count'] as int?) ?? 0) + 1;
    final rounds = ((fails['rounds'] as int?) ?? 0);
    if (count >= maxAttempts) {
      // 30s, 1m, 2m, 4m ... capped at 1h.
      final seconds = min(3600, 30 * pow(2, rounds).toInt());
      final until = _now().add(Duration(seconds: seconds));
      await keys.writeFailures({'count': 0, 'rounds': rounds + 1, 'until': until.millisecondsSinceEpoch});
      return PinLockedOut(until);
    }
    await keys.writeFailures({'count': count, 'rounds': rounds});
    return PinWrong(maxAttempts - count);
  }
}
