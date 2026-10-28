import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../core/sync.dart';
import '../data/repos/audit_repo.dart';
import '../data/repos/ledger_repo.dart';
import '../l10n/app_localizations.dart';
import '../services/ingestion_service.dart';
import '../ui/format.dart';
import '../ui/widgets.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  StreamSubscription<IngestReport>? _reports;
  bool _compromised = false;

  @override
  void initState() {
    super.initState();
    _reports = ref.read(syncProvider).reports.listen(_showReport);
    unawaited(_checkDevice());
  }

  Future<void> _checkDevice() async {
    final bad = await ref.read(bridgeProvider).deviceLooksCompromised();
    if (bad && mounted) {
      setState(() => _compromised = true);
      await ref.read(auditProvider).log(AuditEvent.deviceIntegrityWarning);
    }
  }

  void _showReport(IngestReport r) {
    if (!mounted) return;
    showSnack(context, AppLocalizations.of(context).autoImportSummary(r.added, r.review + r.failed));
  }

  @override
  void dispose() {
    unawaited(_reports?.cancel());
    super.dispose();
  }

  Future<void> _scheduleReminders(List<DueItem> dues) async {
    final l = AppLocalizations.of(context);
    final settings = ref.read(settingsProvider);
    final svc = ref.read(reminderServiceProvider);
    if (!settings.remindersEnabled) {
      await svc.cancelAll();
      return;
    }
    final labels = {for (final d in dues) d.card.id: cardLabel(context, d.card)};
    await svc.schedule(
      dues,
      title: (d, days) => days == 0 ? l.reminderToday(labels[d.card.id]!) : l.reminderSoon(labels[d.card.id]!, days),
      body: l.reminderBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final reviewCount = ref.watch(reviewCountProvider).value ?? 0;
    ref.listen(duesProvider, (_, next) {
      final d = next.value;
      if (d != null) unawaited(_scheduleReminders(d));
    });

    return Scaffold(
      body: Column(
        children: [
          if (_compromised)
            MaterialBanner(
              content: Text(l.deviceCompromisedWarning),
              leading: const Icon(Icons.warning_amber_rounded),
              actions: [TextButton(onPressed: () => setState(() => _compromised = false), child: Text(l.dismiss))],
            ),
          Expanded(child: widget.shell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.shell.currentIndex,
        onDestinationSelected: (i) => widget.shell.goBranch(i, initialLocation: i == widget.shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l.navTransactions,
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: reviewCount > 0,
              label: Text('$reviewCount'),
              child: const Icon(Icons.fact_check_outlined),
            ),
            selectedIcon: const Icon(Icons.fact_check),
            label: l.navReview,
          ),
          NavigationDestination(icon: const Icon(Icons.menu), label: l.navMore),
        ],
      ),
    );
  }
}
