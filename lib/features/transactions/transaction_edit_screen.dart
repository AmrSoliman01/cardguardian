import 'package:cg_core/cg_core.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Values the edit form starts from, also used by the review screen to
/// complete a message no parser understood.
class TxnDraft {
  TxnDraft({
    this.bankCode = 'ABK_EG',
    this.last4 = '',
    this.type = TxnType.purchase,
    this.amountText = '',
    this.currency = 'EGP',
    this.merchant = '',
    DateTime? occurredAt,
    this.categoryId,
    this.note,
  }) : occurredAt = occurredAt ?? DateTime.now();

  String bankCode;
  String last4;
  TxnType type;
  String amountText;
  String currency;
  String merchant;
  DateTime occurredAt;
  int? categoryId;
  String? note;
}

class TransactionEditScreen extends ConsumerStatefulWidget {
  const TransactionEditScreen({super.key, this.id});
  final int? id;

  @override
  ConsumerState<TransactionEditScreen> createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends ConsumerState<TransactionEditScreen> {
  TxnRow? _row;
  CardRow? _card;
  bool _loading = true;
  bool _remember = false;
  final _formKey = GlobalKey<FormState>();
  final _draft = TxnDraft();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.id != null) {
      final v = await ref.read(ledgerProvider).transaction(widget.id!);
      if (v != null) {
        _row = v.txn;
        _card = v.card;
        _draft
          ..bankCode = v.card.bankCode
          ..last4 = v.card.last4
          ..type = v.type
          ..amountText = formatMinor(v.txn.amountMinor, v.txn.currency)
          ..currency = v.txn.currency
          ..merchant = v.txn.merchant
          ..occurredAt = v.txn.occurredAt
          ..categoryId = v.txn.categoryId
          ..note = v.txn.note;
      }
    } else {
      final cards = await ref.read(ledgerProvider).cards();
      if (cards.isNotEmpty) {
        _card = cards.first;
        _draft
          ..bankCode = cards.first.bankCode
          ..last4 = cards.first.last4
          ..currency = cards.first.currency;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final amount = parseMoneyInput(_draft.amountText, _draft.currency)!;
    final ledger = ref.read(ledgerProvider);

    if (_row == null) {
      final r = await ledger.insertParsed(
        ParsedTransaction(
          bankCode: _draft.bankCode,
          last4: _draft.last4,
          type: _draft.type,
          amountMinor: amount,
          currency: _draft.currency,
          merchant: _draft.merchant.trim(),
          occurredAt: _draft.occurredAt,
          parserId: 'manual',
          parserVersion: 1,
        ),
        SourceType.manual,
      );
      if (r.id != null && _draft.categoryId != null) {
        await ledger.setCategory(r.id!, _draft.categoryId, rememberMerchant: _remember);
      }
    } else {
      final cardId = await ledger.ensureCard(_draft.bankCode, _draft.last4, currency: _draft.currency);
      await ledger.updateTransaction(
        TransactionsCompanion(
          id: Value(_row!.id),
          cardId: Value(cardId),
          type: Value(_draft.type.name),
          amountMinor: Value(amount),
          currency: Value(_draft.currency),
          merchant: Value(_draft.merchant.trim()),
          occurredAt: Value(_draft.occurredAt),
          note: Value(_draft.note?.trim().isEmpty == true ? null : _draft.note?.trim()),
        ),
      );
      await ledger.setCategory(_row!.id, _draft.categoryId, rememberMerchant: _remember);
    }
    if (!mounted) return;
    showSnack(context, l.saved);
    context.pop();
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    if (!await confirm(context, title: l.deleteTransactionQ, action: l.delete)) return;
    await ref.read(ledgerProvider).deleteTransaction(_row!.id);
    if (mounted) context.pop();
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _draft.occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_draft.occurredAt));
    setState(() => _draft.occurredAt = DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cards = ref.watch(cardsProvider).value ?? const [];
    final cats = ref.watch(categoriesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_row == null ? l.addTransaction : l.editTransaction),
        actions: [
          if (_row != null) IconButton(icon: const Icon(Icons.delete_outline), tooltip: l.delete, onPressed: _delete),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TxnFields(draft: _draft, cards: cards, initialCard: _card, onPickDate: _pickDateTime),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int?>(
                    initialValue: _draft.categoryId,
                    decoration: InputDecoration(labelText: l.category),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l.uncategorized)),
                      for (final c in cats)
                        DropdownMenuItem(
                          value: c.id,
                          child: Row(
                            children: [
                              CategoryAvatar(c, size: 24),
                              const SizedBox(width: 8),
                              Text(categoryName(context, c)),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (v) => setState(() => _draft.categoryId = v),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v ?? false),
                    title: Text(l.rememberMerchantCategory),
                  ),
                  TextFormField(
                    initialValue: _draft.note,
                    decoration: InputDecoration(labelText: l.note),
                    maxLines: 2,
                    onSaved: (v) => _draft.note = v,
                  ),
                  if (_row != null) ...[
                    const SizedBox(height: 16),
                    Text(l.sourceInfo(_row!.sourceType, _row!.parserId), style: Theme.of(context).textTheme.bodySmall),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _save, child: Text(l.save)),
                ],
              ),
            ),
    );
  }
}

/// Card, type, amount, currency, merchant and date fields.
class TxnFields extends StatefulWidget {
  const TxnFields({super.key, required this.draft, required this.cards, this.initialCard, required this.onPickDate});
  final TxnDraft draft;
  final List<CardRow> cards;
  final CardRow? initialCard;
  final VoidCallback onPickDate;

  @override
  State<TxnFields> createState() => _TxnFieldsState();
}

class _TxnFieldsState extends State<TxnFields> {
  late bool _newCard = widget.cards.isEmpty;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final d = widget.draft;
    final selected = widget.cards.where((c) => c.bankCode == d.bankCode && c.last4 == d.last4).firstOrNull;
    return Column(
      children: [
        if (!_newCard)
          DropdownButtonFormField<int>(
            initialValue: selected?.id,
            decoration: InputDecoration(labelText: l.card),
            items: [
              for (final c in widget.cards) DropdownMenuItem(value: c.id, child: Text(cardLabel(context, c))),
              DropdownMenuItem(value: -1, child: Text(l.otherCard)),
            ],
            validator: (v) => v == null ? l.required : null,
            onChanged: (v) => setState(() {
              if (v == -1) {
                _newCard = true;
                return;
              }
              final c = widget.cards.firstWhere((c) => c.id == v);
              d
                ..bankCode = c.bankCode
                ..last4 = c.last4;
            }),
          )
        else
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: d.bankCode,
                  decoration: InputDecoration(labelText: l.bank),
                  isExpanded: true,
                  items: [
                    for (final b in knownBanks)
                      DropdownMenuItem(
                        value: b.code,
                        child: Text(bankName(context, b.code), overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (v) => d.bankCode = v ?? d.bankCode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: d.last4,
                  decoration: InputDecoration(labelText: l.last4),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  validator: (v) => RegExp(r'^\d{4}$').hasMatch(normalizeDigits(v ?? '')) ? null : l.last4Invalid,
                  onSaved: (v) => d.last4 = normalizeDigits(v ?? ''),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TxnType>(
          initialValue: d.type,
          decoration: InputDecoration(labelText: l.type),
          items: [for (final t in TxnType.values) DropdownMenuItem(value: t, child: Text(txnTypeLabel(l, t)))],
          onChanged: (v) => d.type = v ?? d.type,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: d.amountText,
                decoration: InputDecoration(labelText: l.amount),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final m = parseMoneyInput(v ?? '', d.currency);
                  return (m == null || m <= 0) ? l.amountInvalid : null;
                },
                onSaved: (v) => d.amountText = v ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: d.currency,
                decoration: InputDecoration(labelText: l.currency),
                textCapitalization: TextCapitalization.characters,
                maxLength: 3,
                validator: (v) => RegExp(r'^[A-Za-z]{3}$').hasMatch(v ?? '') ? null : l.currencyInvalid,
                onChanged: (v) => d.currency = v.toUpperCase(),
                onSaved: (v) => d.currency = (v ?? '').toUpperCase(),
              ),
            ),
          ],
        ),
        TextFormField(
          initialValue: d.merchant,
          decoration: InputDecoration(labelText: l.merchant),
          validator: (v) => (v ?? '').trim().isEmpty ? l.required : null,
          onSaved: (v) => d.merchant = v ?? '',
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event),
          title: Text(l.dateTime),
          subtitle: Text(formatDateTime(context, d.occurredAt)),
          onTap: () async {
            widget.onPickDate();
            setState(() {});
          },
        ),
      ],
    );
  }
}
