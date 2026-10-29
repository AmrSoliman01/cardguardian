import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import 'installments_screen.dart';

final _cardProvider = StreamProvider.family<CardRow?, int>((ref, id) => ref.watch(ledgerProvider).watchCard(id));
final _statementsProvider = StreamProvider.family<List<StatementRow>, int>(
  (ref, id) => ref.watch(ledgerProvider).watchStatements(id),
);

class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final card = ref.watch(_cardProvider(id)).value;
    final statements = ref.watch(_statementsProvider(id)).value ?? const [];
    final installments = (ref.watch(installmentsProvider).value ?? const []).where((i) => i.card.id == id).toList();
    if (card == null) return Scaffold(appBar: AppBar(), body: const SizedBox());
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(cardLabel(context, card)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l.edit,
            onPressed: () => _edit(context, ref, card),
          ),
          PopupMenuButton<String>(
            itemBuilder: (_) => [PopupMenuItem(value: 'delete', child: Text(l.deleteCard))],
            onSelected: (_) async {
              if (await confirm(context, title: l.deleteCardQ, message: l.deleteCardMessage, action: l.delete)) {
                await ref.read(ledgerProvider).deleteCard(card.id);
                if (context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bankName(context, card.bankCode), style: t.labelLarge),
                    const SizedBox(height: 8),
                    Text(l.availableLimit, style: t.labelSmall),
                    Text(
                      card.lastAvailableMinor == null
                          ? '—'
                          : formatMoney(card.lastAvailableMinor!, card.lastAvailableCurrency ?? card.currency),
                      textDirection: TextDirection.ltr,
                      style: t.headlineSmall,
                    ),
                    if (card.lastAvailableAt != null)
                      Text(l.asOf(formatDateTime(context, card.lastAvailableAt!)), style: t.bodySmall),
                    const Divider(height: 24),
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: [
                        _kv(
                          context,
                          l.creditLimit,
                          card.creditLimitMinor == null ? '—' : formatMoney(card.creditLimitMinor!, card.currency),
                        ),
                        _kv(context, l.statementDay, card.statementDay?.toString() ?? '—'),
                        _kv(context, l.dueDay, card.dueDay?.toString() ?? '—'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l.viewTransactions),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref.read(txnFilterProvider.notifier).set(ref.read(txnFilterProvider).copyWithCard(card.id));
              context.go('/transactions');
            },
          ),
          SectionTitle(
            l.statementsTitle,
            trailing: TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.add),
              onPressed: () => _addStatement(context, ref, card),
            ),
          ),
          if (statements.isEmpty) ListTile(subtitle: Text(l.noStatements)),
          for (final s in statements)
            ListTile(
              leading: Icon(s.paid ? Icons.check_circle : Icons.pending_outlined, color: s.paid ? Colors.green : null),
              title: Text('${l.due}: ${formatDate(context, s.dueDate)}'),
              subtitle: Text(
                [
                  formatMoney(s.totalDueMinor, s.currency),
                  if (s.minimumDueMinor != null) '${l.minimumDue}: ${formatMoney(s.minimumDueMinor!, s.currency)}',
                ].join(' · '),
              ),
              trailing: PopupMenuButton<String>(
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'paid', child: Text(s.paid ? l.markUnpaid : l.markPaid)),
                  PopupMenuItem(value: 'delete', child: Text(l.delete)),
                ],
                onSelected: (v) => v == 'paid'
                    ? ref.read(ledgerProvider).setStatementPaid(s.id, !s.paid)
                    : ref.read(ledgerProvider).deleteStatement(s.id),
              ),
            ),
          SectionTitle(
            l.installmentsTitle,
            trailing: TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text(l.add),
              onPressed: () => showInstallmentEditor(context, ref, cardId: card.id),
            ),
          ),
          if (installments.isEmpty) ListTile(subtitle: Text(l.noInstallments)),
          for (final i in installments) InstallmentTile(i),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(k, style: Theme.of(context).textTheme.labelSmall),
      Text(v, style: Theme.of(context).textTheme.titleSmall, textDirection: TextDirection.ltr),
    ],
  );

  Future<void> _edit(BuildContext context, WidgetRef ref, CardRow card) async {
    final l = AppLocalizations.of(context);
    final nick = TextEditingController(text: card.nickname ?? '');
    final limit = TextEditingController(
      text: card.creditLimitMinor == null
          ? ''
          : formatMoney(card.creditLimitMinor!, card.currency, showCurrency: false),
    );
    final stmt = TextEditingController(text: card.statementDay?.toString() ?? '');
    final due = TextEditingController(text: card.dueDay?.toString() ?? '');
    int? day(String s) {
      final v = int.tryParse(normalizeDigits(s.trim()));
      return v == null || v < 1 || v > 31 ? null : v;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.editCard),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nick,
                decoration: InputDecoration(labelText: l.nickname),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: limit,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: '${l.creditLimit} (${card.currency})'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stmt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.statementDay, helperText: l.dayOfMonthHelp),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: due,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l.dueDay, helperText: l.dayOfMonthHelp),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.save)),
        ],
      ),
    );
    if (ok != true) return;
    await ref
        .read(ledgerProvider)
        .updateCard(
          CardsCompanion(
            id: Value(card.id),
            nickname: Value(nick.text.trim().isEmpty ? null : nick.text.trim()),
            creditLimitMinor: Value(limit.text.trim().isEmpty ? null : parseMoneyInput(limit.text, card.currency)),
            statementDay: Value(day(stmt.text)),
            dueDay: Value(day(due.text)),
          ),
        );
  }

  Future<void> _addStatement(BuildContext context, WidgetRef ref, CardRow card) async {
    final l = AppLocalizations.of(context);
    final total = TextEditingController();
    final minimum = TextEditingController();
    final now = DateTime.now();
    var dueDate = card.dueDay == null
        ? now.add(const Duration(days: 20))
        : DateTime(now.year, now.month + (now.day > card.dueDay! ? 1 : 0), card.dueDay!.clamp(1, 28));
    final form = GlobalKey<FormState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: Text(l.addStatement),
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: total,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: '${l.totalDue} (${card.currency})'),
                  validator: (v) => parseMoneyInput(v ?? '', card.currency) == null ? l.amountInvalid : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: minimum,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: '${l.minimumDue} (${card.currency})'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: Text(l.dueDate),
                  subtitle: Text(formatDate(c, dueDate)),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: c,
                      initialDate: dueDate,
                      firstDate: DateTime(now.year - 1),
                      lastDate: DateTime(now.year + 1, 12, 31),
                    );
                    if (d != null) set(() => dueDate = d);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
            FilledButton(
              onPressed: () {
                if (form.currentState!.validate()) Navigator.pop(c, true);
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    unawaited(ref.read(reminderServiceProvider).requestPermission());
    await ref
        .read(ledgerProvider)
        .addStatement(
          StatementsCompanion.insert(
            cardId: card.id,
            periodEnd: now,
            dueDate: dueDate,
            totalDueMinor: parseMoneyInput(total.text, card.currency)!,
            minimumDueMinor: Value(parseMoneyInput(minimum.text, card.currency)),
            currency: card.currency,
          ),
        );
  }
}
