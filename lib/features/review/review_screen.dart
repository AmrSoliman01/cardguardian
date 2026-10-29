import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../data/repos/inbox_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import '../transactions/transaction_edit_screen.dart';

/// Messages that need a decision: held by a "review" sender, or not
/// understood by any parser.
class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final items = ref.watch(reviewProvider);
    final pendingCount = items.value?.where((r) => r.status == RawStatus.pending.name).length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navReview),
        actions: [
          if (pendingCount > 1)
            TextButton(onPressed: () => _approveAll(context, ref, items.value!), child: Text(l.approveAll)),
        ],
      ),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? EmptyState(icon: Icons.task_alt, title: l.reviewEmptyTitle, message: l.reviewEmptyMessage)
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (c, i) => _ReviewCard(list[i]),
              ),
      ),
    );
  }

  Future<void> _approveAll(BuildContext context, WidgetRef ref, List<RawRow> rows) async {
    final l = AppLocalizations.of(context);
    final svc = ref.read(ingestionProvider);
    var ok = 0;
    for (final r in rows.where((r) => r.status == RawStatus.pending.name)) {
      if (await svc.approve(r.id, r.toMessage(), bankCode: r.bankCode)) ok++;
    }
    if (context.mounted) showSnack(context, l.approvedCount(ok));
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard(this.row);
  final RawRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final failed = row.status == RawStatus.failed.name;
    final svc = ref.read(ingestionProvider);
    final parsed = ParserRegistry.defaults().parse(row.toMessage(), bankCode: row.bankCode);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(failed ? Icons.help_outline : Icons.hourglass_top, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${row.sender ?? l.sourceName(row.sourceType)} · ${formatDateTime(context, row.receivedAt)}',
                    style: t.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(label: Text(failed ? l.notUnderstood : l.waitingApproval), visualDensity: VisualDensity.compact),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(row.body, style: t.bodyMedium),
            if (parsed is ParseSuccess) ...[
              const SizedBox(height: 8),
              Text(
                '→ ${parsed.transaction.merchant} · ${formatMoney(parsed.transaction.amountMinor, parsed.transaction.currency)}',
                style: t.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (parsed is ParseSuccess)
                  FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: Text(l.approve),
                    onPressed: () => svc.approve(row.id, row.toMessage(), bankCode: row.bankCode),
                  ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: Text(l.enterManually),
                  onPressed: () => _manual(context, ref),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.block),
                  label: Text(l.ignore),
                  onPressed: () => svc.ignore(row.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _manual(BuildContext context, WidgetRef ref) async {
    final cards = await ref.read(ledgerProvider).cards();
    if (!context.mounted) return;
    final draft = TxnDraft(
      bankCode: row.bankCode ?? cards.firstOrNull?.bankCode ?? 'ABK_EG',
      last4: RegExp(r'\*+\s*(\d{4})').firstMatch(row.body)?.group(1) ?? cards.firstOrNull?.last4 ?? '',
      occurredAt: row.receivedAt,
    );
    final form = GlobalKey<FormState>();
    final l = AppLocalizations.of(context);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => StatefulBuilder(
        builder: (c, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(c).bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(row.body, style: Theme.of(c).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  TxnFields(
                    draft: draft,
                    cards: cards,
                    onPickDate: () async {
                      final d = await showDatePicker(
                        context: c,
                        initialDate: draft.occurredAt,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 1)),
                      );
                      if (d != null) setSheet(() => draft.occurredAt = d);
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      if (!form.currentState!.validate()) return;
                      form.currentState!.save();
                      Navigator.pop(c, true);
                    },
                    child: Text(l.save),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (saved != true) return;
    await ref
        .read(ingestionProvider)
        .completeManually(
          row.id,
          ParsedTransaction(
            bankCode: draft.bankCode,
            last4: draft.last4,
            type: draft.type,
            amountMinor: parseMoneyInput(draft.amountText, draft.currency)!,
            currency: draft.currency,
            merchant: draft.merchant.trim(),
            occurredAt: draft.occurredAt,
            parserId: 'manual',
            parserVersion: 1,
          ),
          SourceType.fromName(row.sourceType),
        );
  }
}
