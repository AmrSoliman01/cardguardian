import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ingestion_service.dart';
import 'providers.dart';

/// Pulls messages queued by native code into the ingestion pipeline.
class SyncService {
  SyncService(this.ref);
  final Ref ref;
  Future<IngestReport>? _running;

  /// The latest automatic import, shown as a snackbar by the shell.
  final _reports = StreamController<IngestReport>.broadcast();
  Stream<IngestReport> get reports => _reports.stream;

  Future<IngestReport> drain() {
    return _running ??= _drain().whenComplete(() => _running = null);
  }

  Future<IngestReport> _drain() async {
    final report = IngestReport();
    if (!ref.read(settingsProvider).onboarded) return report;
    final pending = await ref.read(bridgeProvider).drainPending();
    if (pending.isNotEmpty) {
      report.addAll(await ref.read(ingestionProvider).ingest(pending));
      if (report.added + report.review + report.failed > 0) _reports.add(report);
    }
    await ref.read(ingestionProvider).applyRetention();
    return report;
  }
}

final syncProvider = Provider<SyncService>((ref) => SyncService(ref));

/// Mirrors settings into native code and keeps reminders scheduled.
final syncBootstrapProvider = Provider<void>((ref) {
  final bridge = ref.read(bridgeProvider);

  ref.listen(sendersProvider, (_, next) {
    final senders = next.value;
    if (senders == null) return;
    unawaited(
      bridge.setAllowedSenders([
        for (final s in senders)
          if (s.enabled) s.address,
      ]),
    );
  }, fireImmediately: true);

  ref.listen(settingsProvider.select((s) => s.notificationPackages), (_, pkgs) {
    unawaited(bridge.setNotificationPackages(pkgs));
  }, fireImmediately: true);

  ref.listen(settingsProvider.select((s) => s.blockScreenshots), (_, v) {
    unawaited(bridge.setSecureScreen(v));
  });
});
