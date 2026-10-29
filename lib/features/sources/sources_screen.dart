import 'dart:async';

import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../data/repos/audit_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../services/platform_bridge.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Where messages come from, and exactly which senders the app may read.
class SourcesScreen extends ConsumerStatefulWidget {
  const SourcesScreen({super.key});

  @override
  ConsumerState<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends ConsumerState<SourcesScreen> with WidgetsBindingObserver {
  bool _smsGranted = false;
  bool _notifGranted = false;
  List<NotificationApp> _apps = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The user may come back from system settings.
    if (state == AppLifecycleState.resumed) unawaited(_refresh());
  }

  Future<void> _refresh() async {
    final b = ref.read(bridgeProvider);
    final sms = await b.hasSmsPermission();
    final notif = await b.notificationAccessEnabled();
    final apps = await b.notificationApps();
    if (mounted) {
      setState(() {
        _smsGranted = sms;
        _notifGranted = notif;
        _apps = apps;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final senders = ref.watch(sendersProvider).value ?? const [];
    final caps = ref.watch(capabilitiesProvider).value ?? const PlatformCapabilities();
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.sourcesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l.addSender),
        onPressed: () => showSenderEditor(context, ref),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(l.sendersExplainer, style: Theme.of(context).textTheme.bodyMedium),
          ),
          SectionTitle(l.allowedSenders),
          if (senders.isEmpty) ListTile(leading: const Icon(Icons.info_outline), title: Text(l.noSenders)),
          for (final s in senders) _SenderTile(s),

          if (caps.sms) ...[
            SectionTitle(l.smsSourceTitle),
            ListTile(
              leading: Icon(_smsGranted ? Icons.check_circle : Icons.sms_outlined),
              title: Text(_smsGranted ? l.smsAllowed : l.smsNotAllowed),
              subtitle: Text(l.smsExplainer),
              trailing: _smsGranted
                  ? null
                  : FilledButton(
                      onPressed: () async {
                        final ok = await ref.read(bridgeProvider).requestSmsPermission();
                        if (!ok && context.mounted) showSnack(context, l.permissionRestrictedHint);
                        await _refresh();
                        unawaited(ref.read(auditProvider).log(AuditEvent.sourceEnabled, {'source': 'sms'}));
                      },
                      child: Text(l.allow),
                    ),
            ),
            if (_smsGranted)
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(l.smsHistoryTitle),
                subtitle: Text(l.smsHistorySubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/import/sms'),
              ),
          ],

          if (caps.notificationListener) ...[
            SectionTitle(l.notificationSourceTitle),
            ListTile(
              leading: Icon(_notifGranted ? Icons.check_circle : Icons.notifications_outlined),
              title: Text(_notifGranted ? l.notificationsAllowed : l.notificationsNotAllowed),
              subtitle: Text(l.notificationsExplainer),
              trailing: TextButton(
                onPressed: () => ref.read(bridgeProvider).openNotificationAccessSettings(),
                child: Text(_notifGranted ? l.manage : l.allow),
              ),
            ),
            if (_notifGranted)
              for (final app in _apps)
                CheckboxListTile(
                  value: settings.notificationPackages.contains(app.packageName),
                  title: Text(app.label),
                  subtitle: Text(app.packageName),
                  onChanged: (v) {
                    final next = {...settings.notificationPackages};
                    v == true ? next.add(app.packageName) : next.remove(app.packageName);
                    unawaited(
                      ref
                          .read(settingsProvider.notifier)
                          .update((s) => s.copyWith(notificationPackages: next.toList())),
                    );
                  },
                ),
            if (_notifGranted && _apps.isEmpty)
              ListTile(leading: const Icon(Icons.info_outline), subtitle: Text(l.notificationAppsEmpty)),
          ],

          if (caps.shortcuts) ...[
            SectionTitle(l.shortcutSourceTitle),
            ListTile(
              leading: const Icon(Icons.bolt_outlined),
              title: Text(l.shortcutSetupTitle),
              subtitle: Text(l.shortcutSetupSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/sources/ios-guide'),
            ),
          ],

          SectionTitle(l.manualSourcesTitle),
          ListTile(
            leading: const Icon(Icons.content_paste_go),
            title: Text(l.pasteImportTitle),
            subtitle: Text(l.pasteImportSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/import/paste'),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: Text(l.csvImportTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/import/csv'),
          ),
        ],
      ),
    );
  }
}

class _SenderTile extends ConsumerWidget {
  const _SenderTile(this.s);
  final SenderRow s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final mode = SenderMode.fromName(s.mode);
    final parts = [
      bankName(context, s.bankCode),
      mode == SenderMode.auto ? l.modeAuto : l.modeReview,
      if (s.mustContain != null) l.filterContains(s.mustContain!),
    ];
    return ListTile(
      leading: const Icon(Icons.account_balance_outlined),
      title: Text(s.address),
      subtitle: Text(parts.join(' · ')),
      trailing: Switch(
        value: s.enabled,
        onChanged: (v) async {
          await ref.read(inboxProvider).updateSender(s.id, enabled: v);
          await ref.read(auditProvider).log(v ? AuditEvent.sourceEnabled : AuditEvent.sourceDisabled, {
            'kind': 'sender',
          });
        },
      ),
      onTap: () => showSenderEditor(context, ref, existing: s),
    );
  }
}

/// Add or edit an allowed sender.
Future<void> showSenderEditor(BuildContext context, WidgetRef ref, {SenderRow? existing, String? address}) async {
  final l = AppLocalizations.of(context);
  final addr = TextEditingController(text: existing?.address ?? address ?? '');
  final filter = TextEditingController(text: existing?.mustContain ?? '');
  var bank = existing?.bankCode ?? 'ABK_EG';
  var mode = existing == null ? SenderMode.auto : SenderMode.fromName(existing.mode);
  final form = GlobalKey<FormState>();

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (c) => StatefulBuilder(
      builder: (c, set) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(c).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(existing == null ? l.addSender : l.editSender, style: Theme.of(c).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addr,
                  decoration: InputDecoration(labelText: l.senderId, helperText: l.senderHelp),
                  validator: (v) => (v ?? '').trim().isEmpty ? l.required : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: bank,
                  decoration: InputDecoration(labelText: l.bank),
                  items: [
                    for (final b in knownBanks) DropdownMenuItem(value: b.code, child: Text(bankName(c, b.code))),
                  ],
                  onChanged: (v) => bank = v ?? bank,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: filter,
                  decoration: InputDecoration(labelText: l.mustContainLabel, helperText: l.mustContainHelp),
                ),
                const SizedBox(height: 12),
                SegmentedButton<SenderMode>(
                  segments: [
                    ButtonSegment(value: SenderMode.auto, label: Text(l.modeAuto), icon: const Icon(Icons.bolt)),
                    ButtonSegment(
                      value: SenderMode.review,
                      label: Text(l.modeReview),
                      icon: const Icon(Icons.fact_check_outlined),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (v) => set(() => mode = v.first),
                ),
                const SizedBox(height: 8),
                Text(
                  mode == SenderMode.auto ? l.modeAutoHelp : l.modeReviewHelp,
                  style: Theme.of(c).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (existing != null)
                      TextButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l.delete),
                        onPressed: () => Navigator.pop(c, 'delete'),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (form.currentState!.validate()) Navigator.pop(c, 'save');
                      },
                      child: Text(l.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  final inbox = ref.read(inboxProvider);
  if (result == 'delete' && existing != null) {
    await inbox.deleteSender(existing.id);
  } else if (result == 'save') {
    if (existing == null) {
      await inbox.addSender(address: addr.text, bankCode: bank, mode: mode, mustContain: filter.text);
      await ref.read(auditProvider).log(AuditEvent.sourceEnabled, {'kind': 'sender'});
    } else {
      await inbox.updateSender(
        existing.id,
        address: addr.text,
        bankCode: bank,
        mode: mode,
        mustContain: filter.text,
        clearFilter: filter.text.trim().isEmpty,
      );
    }
  }
}
