import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ingestion_service.dart';
import '../../ui/format.dart';

class PickItem {
  PickItem(this.message, this.result, {required this.duplicate}) : selected = result is ParseSuccess && !duplicate;
  final RawMessage message;
  final ParseResult result;
  final bool duplicate;
  bool selected;
}

/// Parses [messages] and flags ones already stored, for a preview list.
Future<List<PickItem>> buildPickItems(WidgetRef ref, List<RawMessage> messages, {String? bankCode}) async {
  final registry = ParserRegistry.defaults();
  final results = [for (final m in messages) registry.parse(m, bankCode: bankCode)];
  final hashes = [
    for (final r in results)
      if (r is ParseSuccess) transactionHash(r.transaction),
  ];
  final existing = await ref.read(ledgerProvider).existingHashes(hashes);
  return [
    for (var i = 0; i < messages.length; i++)
      PickItem(
        messages[i],
        results[i],
        duplicate:
            results[i] is ParseSuccess && existing.contains(transactionHash((results[i] as ParseSuccess).transaction)),
      ),
  ];
}

/// Checkbox list where the user ticks exactly which messages to import.
class MessagePicker extends StatefulWidget {
  const MessagePicker({super.key, required this.items, required this.onImport, this.header});
  final List<PickItem> items;
  final Future<void> Function(List<RawMessage> selected) onImport;
  final Widget? header;

  @override
  State<MessagePicker> createState() => _MessagePickerState();
}

class _MessagePickerState extends State<MessagePicker> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final items = widget.items;
    final selected = items.where((i) => i.selected).toList();
    final parsedCount = items.where((i) => i.result is ParseSuccess).length;

    return Column(
      children: [
        ?widget.header,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              Expanded(child: Text(l.previewCounts(items.length, parsedCount, selected.length), style: t.bodySmall)),
              TextButton(
                onPressed: () => setState(() {
                  final all = selected.length != items.length;
                  for (final i in items) {
                    i.selected = all;
                  }
                }),
                child: Text(selected.length == items.length ? l.selectNone : l.selectAll),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (c, i) {
              final it = items[i];
              final r = it.result;
              final String status;
              if (r is ParseSuccess) {
                final tx = r.transaction;
                status =
                    '${tx.merchant} · ${formatMoney(tx.amountMinor, tx.currency)} · ${formatDateTime(context, tx.occurredAt)}'
                    '${it.duplicate ? ' · ${l.alreadyAdded}' : ''}';
              } else if (r is ParseIgnored) {
                status = l.notATransaction;
              } else {
                status = l.notUnderstoodWillReview;
              }
              return CheckboxListTile(
                value: it.selected,
                onChanged: (v) => setState(() => it.selected = v ?? false),
                title: Text(it.message.body, maxLines: 3, overflow: TextOverflow.ellipsis, style: t.bodySmall),
                subtitle: Text(
                  status,
                  style: t.labelMedium?.copyWith(
                    color: r is ParseSuccess && !it.duplicate
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: _busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.download_done),
                label: Text(l.importSelected(selected.length)),
                onPressed: _busy || selected.isEmpty
                    ? null
                    : () async {
                        setState(() => _busy = true);
                        await widget.onImport([for (final s in selected) s.message]);
                        if (mounted) setState(() => _busy = false);
                      },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showImportReport(BuildContext context, IngestReport r) {
  final l = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      icon: const Icon(Icons.task_alt),
      title: Text(l.importDone),
      content: Text(l.importReport(r.added, r.duplicates, r.failed + r.review, r.ignored)),
      actions: [FilledButton(onPressed: () => Navigator.pop(c), child: Text(l.ok))],
    ),
  );
}
