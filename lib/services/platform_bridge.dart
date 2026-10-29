import 'dart:io';

import 'package:cg_core/cg_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SmsSenderSummary {
  const SmsSenderSummary(this.address, this.count, this.lastAt);
  final String address;
  final int count;
  final DateTime lastAt;
}

class NotificationApp {
  const NotificationApp(this.packageName, this.label);
  final String packageName;
  final String label;
}

/// Platform features available on this device/build.
class PlatformCapabilities {
  const PlatformCapabilities({
    this.sms = false,
    this.notificationListener = false,
    this.shortcuts = false,
    this.flavor = '',
  });

  /// Android `personal` build only: read SMS directly.
  final bool sms;

  /// Android: read bank alerts from notifications.
  final bool notificationListener;

  /// iOS: receive messages from the Shortcuts automation.
  final bool shortcuts;
  final String flavor;
}

/// Talks to the native side (Kotlin on Android, Swift on iOS).
///
/// Native code only ever hands over messages from senders/apps the user
/// allowed; everything else is dropped before it reaches Dart.
class PlatformBridge {
  PlatformBridge({MethodChannel? channel}) : _ch = channel ?? const MethodChannel('cardguardian/native');

  final MethodChannel _ch;
  VoidCallback? _onPending;

  bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  void listen({required VoidCallback onPendingAvailable}) {
    _onPending = onPendingAvailable;
    if (!_supported) return;
    _ch.setMethodCallHandler((call) async {
      if (call.method == 'pendingAvailable') _onPending?.call();
      return null;
    });
  }

  Future<T?> _call<T>(String method, [Object? args]) async {
    if (!_supported) return null;
    try {
      return await _ch.invokeMethod<T>(method, args);
    } on MissingPluginException {
      return null;
    }
  }

  Future<PlatformCapabilities> capabilities() async {
    final m = await _call<Map<Object?, Object?>>('capabilities');
    if (m == null) return const PlatformCapabilities();
    return PlatformCapabilities(
      sms: m['sms'] == true,
      notificationListener: m['notificationListener'] == true,
      shortcuts: m['shortcuts'] == true,
      flavor: (m['flavor'] as String?) ?? '',
    );
  }

  /// Takes every message queued natively (SMS receiver, notification
  /// listener, Shortcuts) and removes it from the native queue.
  Future<List<RawMessage>> drainPending() async {
    final list = await _call<List<Object?>>('drainPending') ?? const [];
    return [for (final e in list.cast<Map<Object?, Object?>>()) _toRaw(e)];
  }

  static RawMessage _toRaw(Map<Object?, Object?> e) => RawMessage(
    sourceType: SourceType.fromName(e['source'] as String? ?? 'sms'),
    sender: e['sender'] as String?,
    body: e['body'] as String? ?? '',
    receivedAt: DateTime.fromMillisecondsSinceEpoch((e['receivedAt'] as num?)?.toInt() ?? 0),
  );

  /// Tells native code which senders it may accept. Messages from anyone
  /// else are never queued.
  Future<void> setAllowedSenders(List<String> addresses) => _call<void>('setAllowedSenders', addresses);

  Future<void> setNotificationPackages(List<String> packages) => _call<void>('setNotificationPackages', packages);

  // -------------------------------------------------------------- Android SMS

  Future<bool> hasSmsPermission() async => await _call<bool>('hasSmsPermission') ?? false;

  Future<bool> requestSmsPermission() async => await _call<bool>('requestSmsPermission') ?? false;

  /// Distinct senders in the SMS inbox with message counts. No message text.
  Future<List<SmsSenderSummary>> smsSenders() async {
    final list = await _call<List<Object?>>('smsSenders') ?? const [];
    return [
      for (final e in list.cast<Map<Object?, Object?>>())
        SmsSenderSummary(
          e['address'] as String,
          (e['count'] as num).toInt(),
          DateTime.fromMillisecondsSinceEpoch((e['lastAt'] as num).toInt()),
        ),
    ];
  }

  /// Reads SMS from the given senders only, newest first.
  Future<List<RawMessage>> readSms(List<String> addresses, {DateTime? since, int limit = 5000}) async {
    final list =
        await _call<List<Object?>>('readSms', {
          'addresses': addresses,
          'since': since?.millisecondsSinceEpoch,
          'limit': limit,
        }) ??
        const [];
    return [for (final e in list.cast<Map<Object?, Object?>>()) _toRaw(e)];
  }

  // ------------------------------------------------- Android notifications

  Future<bool> notificationAccessEnabled() async => await _call<bool>('notificationAccessEnabled') ?? false;

  Future<void> openNotificationAccessSettings() => _call<void>('openNotificationAccessSettings');

  /// Apps that posted notifications since access was granted (names only),
  /// plus the default SMS app.
  Future<List<NotificationApp>> notificationApps() async {
    final list = await _call<List<Object?>>('notificationApps') ?? const [];
    return [
      for (final e in list.cast<Map<Object?, Object?>>())
        NotificationApp(e['package'] as String, (e['label'] as String?) ?? e['package'] as String),
    ];
  }

  // ------------------------------------------------------------- security

  Future<void> setSecureScreen(bool secure) => _call<void>('setSecureScreen', secure);

  /// True when the device looks rooted/jailbroken. A warning, not a block.
  Future<bool> deviceLooksCompromised() async => await _call<bool>('deviceLooksCompromised') ?? false;
}
