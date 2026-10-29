import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/providers.dart';
import '../../data/repos/audit_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../services/pin_service.dart';
import '../../ui/format.dart';
import 'pin_pad.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pad = GlobalKey<PinPadState>();
  final _auth = LocalAuthentication();
  String? _error;
  bool _busy = false;
  DateTime? _lockedUntil;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    if (ref.read(settingsProvider).biometricsEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_biometric()));
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _biometric() async {
    final l = AppLocalizations.of(context);
    try {
      final ok = await _auth.authenticate(localizedReason: l.unlockReason, biometricOnly: true);
      if (ok && mounted) ref.read(lockProvider.notifier).unlock();
    } on LocalAuthException {
      // Fall back to the PIN.
    }
  }

  Future<void> _submit(String pin) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    final r = await ref.read(pinServiceProvider).verify(pin);
    if (!mounted) return;
    _pad.currentState?.clear();
    switch (r) {
      case PinOk():
        ref.read(lockProvider.notifier).unlock();
      case PinWrong(:final attemptsLeft):
        setState(() => _error = l.pinWrong(attemptsLeft));
        unawaited(ref.read(auditProvider).log(AuditEvent.unlockFailed));
      case PinLockedOut(:final until):
        _startCountdown(until);
        unawaited(ref.read(auditProvider).log(AuditEvent.unlockFailed, {'lockedOut': true}));
    }
    setState(() => _busy = false);
  }

  void _startCountdown(DateTime until) {
    _lockedUntil = until;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (DateTime.now().isAfter(until)) {
        t.cancel();
        setState(() {
          _lockedUntil = null;
          _error = null;
        });
      } else {
        setState(() {});
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final biometrics = ref.watch(settingsProvider.select((s) => s.biometricsEnabled));
    final lockedFor = _lockedUntil?.difference(DateTime.now()).inSeconds;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, size: 56, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text(l.appTitle, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(l.enterPin),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: Text(
                    lockedFor != null ? l.pinLockedOut(lockedFor + 1) : (_error ?? ''),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
                PinPad(
                  key: _pad,
                  enabled: !_busy && _lockedUntil == null,
                  onSubmit: _submit,
                  leadingAction: biometrics
                      ? IconButton(
                          icon: const Icon(Icons.fingerprint, size: 32),
                          tooltip: l.useBiometrics,
                          onPressed: _biometric,
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                Text(formatDate(context, DateTime.now()), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
