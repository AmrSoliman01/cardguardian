import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../data/repos/ledger_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

class InstallmentsScreen extends ConsumerWidget {
  const InstallmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final list = ref.watch(installmentsProvider).value ?? const [];
    final active = list.where((i) => i.remainingMonths > 0).toList();
    final totals = <String, int>{};
    for (final i in active) {
      totals[i.row.currency] = (totals[i.row.currency] ?? 0) + i.remainingMinor;
    }
    final monthly = <String, int>{};
    for (final i in active) {
      monthly[i.row.currency] = (monthly[i.row.currency] ?? 0) + i.row.monthlyMinor;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.installmentsTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.addInstallment,
        onPressed: () => showInstallmentEditor(context, ref),
        child: const Icon(Icons.add),
      ),
      body: list.isEmpty
          ? EmptyState(icon: Icons.calendar_month_outlined, title: l.noInstallments, message: l.installmentsHelp)
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                if (totals.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.remainingTotal, style: Theme.of(context).textTheme.labelLarge),
                            for (final e in totals.entries)
                              Text(
                                formatMoney(e.value, e.key),
                                textDirection: TextDirection.ltr,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            const SizedBox(height: 4),
                            for (final e in monthly.entries) Text(l.perMonth(formatMoney(e.value, e.key))),
                          ],
                        ),
                      ),
                    ),
                  ),
                for (final i in list) InstallmentTile(i),
              ],
            ),
    );
  }
}

class InstallmentTile extends ConsumerWidget {
  const InstallmentTile(this.i, {super.key});
  final InstallmentView i;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final done = i.remainingMonths == 0;
    return ListTile(
      leading: CircularProgressIndicator(value: i.paidMonths / i.row.months, strokeWidth: 4),
      title: Text(i.row.merchant),
      subtitle: Text(
        '${cardLabel(context, i.card)} · ${l.monthsProgress(i.paidMonths, i.row.months)}'
        '${done ? '' : ' · ${l.remaining}: ${formatMoney(i.remainingMinor, i.row.currency)}'}',
      ),
      trailing: Text(formatMoney(i.row.monthlyMinor, i.row.currency), textDirection: TextDirection.ltr),
      onLongPress: () async {
        if (await confirm(context, title: l.deleteInstallmentQ, action: l.delete)) {
          await ref.read(ledgerProvider).deleteInstallment(i.row.id);
        }
      },
    );
  }
}

Future<void> showInstallmentEditor(BuildContext context, WidgetRef ref, {int? cardId}) async {
  final l = AppLocalizations.of(context);
  final cards = await ref.read(ledgerProvider).cards();
  if (!context.mounted) return;
  if (cards.isEmpty) {
    showSnack(context, l.noCardsTitle);
    return;
  }
  var card = cards.firstWhere((c) => c.id == cardId, orElse: () => cards.first);
  final merchant = TextEditingController();
  final total = TextEditingController();
  final months = TextEditingController(text: '12');
  var start = DateTime(DateTime.now().year, DateTime.now().month);
  final form = GlobalKey<FormState>();

  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, set) => AlertDialog(
        title: Text(l.addInstallment),
        content: Form(
          key: form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: card.id,
                  decoration: InputDecoration(labelText: l.card),
                  items: [for (final c in cards) DropdownMenuItem(value: c.id, child: Text(cardLabel(context, c)))],
                  onChanged: (v) => card = cards.firstWhere((c) => c.id == v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: merchant,
                  decoration: InputDecoration(labelText: l.merchant),
                  validator: (v) => (v ?? '').trim().isEmpty ? l.required : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: total,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: '${l.totalAmount} (${card.currency})'),
                  validator: (v) => parseMoneyInput(v ?? '', card.currency) == null ? l.amountInvalid : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: months,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.months),
                  validator: (v) {
                    final n = int.tryParse(normalizeDigits(v ?? ''));
                    return n == null || n < 1 || n > 120 ? l.required : null;
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.firstInstallmentMonth),
                  subtitle: Text(formatMonth(c, start)),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: c,
                      initialDate: start,
                      firstDate: DateTime(2015),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (d != null) set(() => start = DateTime(d.year, d.month));
                  },
                ),
              ],
            ),
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
  final totalMinor = parseMoneyInput(total.text, card.currency)!;
  final n = int.parse(normalizeDigits(months.text));
  await ref
      .read(ledgerProvider)
      .addInstallment(
        InstallmentsCompanion.insert(
          cardId: card.id,
          merchant: merchant.text.trim(),
          totalMinor: totalMinor,
          // Rounded up so the plan never under-counts what is owed.
          monthlyMinor: (totalMinor + n - 1) ~/ n,
          currency: card.currency,
          months: n,
          startDate: start,
          note: const Value(null),
        ),
      );
}
