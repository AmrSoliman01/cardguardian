import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/providers.dart';
import '../../data/repos/audit_repo.dart';
import '../../l10n/app_localizations.dart';
import '../lock/pin_pad.dart';

/// First launch: language -> privacy -> PIN -> biometrics -> which banks.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String? _firstPin;
  String? _pinError;
  bool _biometricsAvailable = false;
  bool _useBiometrics = false;
  bool _busy = false;
  final _pinPad = GlobalKey<PinPadState>();

  /// Bank code -> chosen sender ID (editable).
  final Map<String, String> _banks = {'ABK_EG': 'ABK-Egypt'};

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final auth = LocalAuthentication();
      final ok = await auth.canCheckBiometrics && await auth.isDeviceSupported();
      if (mounted) setState(() => _biometricsAvailable = ok);
    } catch (_) {}
  }

  void _setLanguage(String code) =>
      ref.read(settingsProvider.notifier).update((s) => s.copyWith(localeCode: code)).then((_) => _next());

  void _next() => setState(() => _step++);

  void _onPin(String pin) {
    final l = AppLocalizations.of(context);
    _pinPad.currentState?.clear();
    if (_firstPin == null) {
      setState(() {
        _firstPin = pin;
        _pinError = null;
      });
      return;
    }
    if (_firstPin != pin) {
      setState(() {
        _firstPin = null;
        _pinError = l.pinMismatch;
      });
      return;
    }
    _savePin(pin);
  }

  Future<void> _savePin(String pin) async {
    setState(() => _busy = true);
    await ref.read(pinServiceProvider).setPin(pin);
    setState(() => _busy = false);
    _next();
    if (!_biometricsAvailable) _next();
  }

  Future<void> _enableBiometrics() async {
    final l = AppLocalizations.of(context);
    try {
      final ok = await LocalAuthentication().authenticate(
        localizedReason: l.enableBiometricsReason,
        biometricOnly: true,
      );
      setState(() => _useBiometrics = ok);
    } on LocalAuthException {
      setState(() => _useBiometrics = false);
    }
    _next();
  }

  Future<void> _finish() async {
    setState(() => _busy = true);
    final inbox = ref.read(inboxProvider);
    for (final e in _banks.entries) {
      if (e.value.trim().isEmpty) continue;
      await inbox.addSender(address: e.value, bankCode: e.key, mustContain: e.key == 'ABK_EG' ? 'Credit Card#' : null);
    }
    await ref.read(auditProvider).log(AuditEvent.appSetup, {'banks': _banks.length});
    ref.read(lockProvider.notifier).unlock();
    await ref
        .read(settingsProvider.notifier)
        .update((s) => s.copyWith(onboarded: true, biometricsEnabled: _useBiometrics));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final pages = <Widget>[
      // 0. Language
      _Page(
        icon: Icons.translate,
        title: 'اختر اللغة / Choose language',
        children: [
          FilledButton(onPressed: () => _setLanguage('ar'), child: const Text('العربية')),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () => _setLanguage('en'), child: const Text('English')),
        ],
      ),
      // 1. Privacy promise
      _Page(
        icon: Icons.shield_outlined,
        title: l.welcomeTitle,
        children: [
          for (final line in [l.privacyPoint1, l.privacyPoint2, l.privacyPoint3, l.privacyPoint4])
            ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(line)),
          const SizedBox(height: 16),
          FilledButton(onPressed: _next, child: Text(l.next)),
        ],
      ),
      // 2. PIN
      _Page(
        icon: Icons.pin_outlined,
        title: _firstPin == null ? l.createPin : l.confirmPin,
        subtitle: _pinError ?? l.pinHint,
        children: [PinPad(key: _pinPad, onSubmit: _onPin, enabled: !_busy)],
      ),
      // 3. Biometrics
      _Page(
        icon: Icons.fingerprint,
        title: l.biometricsTitle,
        subtitle: l.biometricsSubtitle,
        children: [
          FilledButton(onPressed: _enableBiometrics, child: Text(l.enable)),
          const SizedBox(height: 8),
          TextButton(onPressed: _next, child: Text(l.notNow)),
        ],
      ),
      // 4. Banks / senders
      _Page(
        icon: Icons.account_balance_outlined,
        title: l.chooseBanksTitle,
        subtitle: l.chooseBanksSubtitle,
        children: [
          for (final b in knownBanks.where((b) => b.code != 'OTHER'))
            CheckboxListTile(
              value: _banks.containsKey(b.code),
              title: Text(Localizations.localeOf(context).languageCode == 'ar' ? b.nameAr : b.nameEn),
              subtitle: Text(l.senderLabel(_banks[b.code] ?? b.defaultSenders.first)),
              secondary: _banks.containsKey(b.code)
                  ? IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: l.editSender,
                      onPressed: () => _editSender(b.code),
                    )
                  : null,
              onChanged: (v) => setState(() {
                if (v == true) {
                  _banks[b.code] = b.defaultSenders.first;
                } else {
                  _banks.remove(b.code);
                }
              }),
            ),
          const SizedBox(height: 8),
          Text(l.chooseBanksFootnote, style: t.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: _busy ? null : _finish, child: Text(l.finishSetup)),
        ],
      ),
    ];

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) setState(() => _step--);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(value: (_step + 1) / pages.length),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: KeyedSubtree(key: ValueKey(_step), child: pages[_step]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editSender(String bankCode) async {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: _banks[bankCode]);
    final v = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.editSender),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(helperText: l.senderHelp),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, ctrl.text), child: Text(l.save)),
        ],
      ),
    );
    if (v != null && v.trim().isNotEmpty) setState(() => _banks[bankCode] = v.trim());
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.icon, required this.title, this.subtitle, required this.children});
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(title, style: t.headlineSmall, textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: t.bodyMedium, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
