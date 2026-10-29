import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../services/platform_bridge.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import 'message_picker.dart';

/// Android (personal build): pick senders, then tick the exact old messages
/// to import. Only the chosen senders' messages are ever read.
class SmsHistoryScreen extends ConsumerStatefulWidget {
  const SmsHistoryScreen({super.key});

  @override
  ConsumerState<SmsHistoryScreen> createState() => _SmsHistoryScreenState();
}

class _SmsHistoryScreenState extends ConsumerState<SmsHistoryScreen> {
  List<SmsSenderSummary>? _senders;
  final Set<String> _chosen = {};
  int _months = 12;
  List<PickItem>? _items;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bridge = ref.read(bridgeProvider);
    if (!await bridge.hasSmsPermission() && !await bridge.requestSmsPermission()) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final senders = await bridge.smsSenders();
    final allowed = (await ref.read(inboxProvider).senders())
        .where((s) => s.enabled)
        .map((s) => normalizeSender(s.address));
    if (!mounted) return;
    setState(() {
      _senders = senders;
      _chosen.addAll(senders.where((s) => allowed.contains(normalizeSender(s.address))).map((s) => s.address));
      _loading = false;
    });
  }

  Future<void> _readMessages() async {
    setState(() => _loading = true);
    final since = _months == 0 ? null : DateTime.now().subtract(Duration(days: 30 * _months));
    final msgs = await ref.read(bridgeProvider).readSms(_chosen.toList(), since: since);
    final items = await buildPickItems(ref, msgs);
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  Future<void> _import(List<RawMessage> selected) async {
    // Senders the user picked here become allowed senders for new messages too.
    final inbox = ref.read(inboxProvider);
    final known = (await inbox.senders()).map((s) => normalizeSender(s.address)).toSet();
    final registry = ParserRegistry.defaults();
    for (final address in _chosen) {
      if (known.contains(normalizeSender(address))) continue;
      final sample = selected.where((m) => m.sender == address).firstOrNull;
      final r = sample == null ? null : registry.parse(sample);
      await inbox.addSender(address: address, bankCode: r is ParseSuccess ? r.transaction.bankCode : 'OTHER');
    }
    final report = await ref.read(ingestionProvider).ingest(selected, userPicked: true);
    if (!mounted) return;
    await showImportReport(context, report);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_items != null) {
      body = MessagePicker(items: _items!, onImport: _import);
    } else if (_senders == null) {
      body = EmptyState(icon: Icons.sms_failed_outlined, title: l.smsPermissionNeeded);
    } else {
      body = Column(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(l.smsHistoryExplainer)),
          Expanded(
            child: ListView(
              children: [
                for (final s in _senders!)
                  CheckboxListTile(
                    value: _chosen.contains(s.address),
                    title: Text(s.address),
                    subtitle: Text('${l.messagesCount(s.count)} · ${formatDate(context, s.lastAt)}'),
                    onChanged: (v) => setState(() => v == true ? _chosen.add(s.address) : _chosen.remove(s.address)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<int>(
              initialValue: _months,
              decoration: InputDecoration(labelText: l.howFarBack),
              items: [
                DropdownMenuItem(value: 3, child: Text(l.lastMonths(3))),
                DropdownMenuItem(value: 12, child: Text(l.lastMonths(12))),
                DropdownMenuItem(value: 0, child: Text(l.allTime)),
              ],
              onChanged: (v) => setState(() => _months = v ?? 12),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: _chosen.isEmpty ? null : _readMessages, child: Text(l.showMessages)),
              ),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.smsHistoryTitle)),
      body: body,
    );
  }
}
