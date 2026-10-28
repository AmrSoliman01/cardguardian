import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/repos/ledger_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _setFilter(TxnFilter Function(TxnFilter f) change) =>
      ref.read(txnFilterProvider.notifier).set(change(ref.read(txnFilterProvider)));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final filter = ref.watch(txnFilterProvider);
    final txns = ref.watch(transactionsProvider);
    final cards = ref.watch(cardsProvider).value ?? const [];
    final cats = ref.watch(categoriesProvider).value ?? const [];

    TxnFilter copy({Object? cardId = _keep, Object? type = _keep, Object? categoryId = _keep, String? query}) =>
        TxnFilter(
          cardId: identical(cardId, _keep) ? filter.cardId : cardId as int?,
          type: identical(type, _keep) ? filter.type : type as TxnType?,
          categoryId: identical(categoryId, _keep) ? filter.categoryId : categoryId as int?,
          query: query ?? filter.query,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navTransactions),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: l.searchMerchant,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _search.clear();
                              _setFilter((_) => copy(query: ''));
                            },
                          ),
                  ),
                  onChanged: (v) => _setFilter((_) => copy(query: v)),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _MenuChip<int?>(
                      label: filter.cardId == null
                          ? l.allCards
                          : cardLabel(
                              context,
                              cards.firstWhere((c) => c.id == filter.cardId, orElse: () => cards.first),
                            ),
                      selected: filter.cardId != null,
                      options: {null: l.allCards, for (final c in cards) c.id: cardLabel(context, c)},
                      onSelected: (v) => _setFilter((_) => copy(cardId: v)),
                    ),
                    _MenuChip<TxnType?>(
                      label: filter.type == null ? l.allTypes : txnTypeLabel(l, filter.type!),
                      selected: filter.type != null,
                      options: {null: l.allTypes, for (final t in TxnType.values) t: txnTypeLabel(l, t)},
                      onSelected: (v) => _setFilter((_) => copy(type: v)),
                    ),
                    _MenuChip<int?>(
                      label: filter.categoryId == null
                          ? l.allCategories
                          : categoryName(context, cats.firstWhere((c) => c.id == filter.categoryId)),
                      selected: filter.categoryId != null,
                      options: {null: l.allCategories, for (final c in cats) c.id: categoryName(context, c)},
                      onSelected: (v) => _setFilter((_) => copy(categoryId: v)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-transactions',
        tooltip: l.addTransaction,
        onPressed: () => context.push('/txn/new'),
        child: const Icon(Icons.add),
      ),
      body: txns.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) return EmptyState(icon: Icons.receipt_long_outlined, title: l.noTransactions);
          final items = <Object>[];
          DateTime? day;
          for (final v in list) {
            final d = DateTime(v.txn.occurredAt.year, v.txn.occurredAt.month, v.txn.occurredAt.day);
            if (day != d) {
              items.add(d);
              day = d;
            }
            items.add(v);
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: items.length,
            itemBuilder: (c, i) {
              final it = items[i];
              if (it is DateTime) {
                return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
                  child: Text(formatDate(context, it), style: Theme.of(context).textTheme.labelLarge),
                );
              }
              return TxnTile(it as TxnView);
            },
          );
        },
      ),
    );
  }
}

const _keep = Object();

class TxnTile extends StatelessWidget {
  const TxnTile(this.v, {super.key});
  final TxnView v;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = v.txn;
    final subtitle = [
      cardLabel(context, v.card),
      if (v.type != TxnType.purchase) txnTypeLabel(l, v.type),
      formatDateTime(context, t.occurredAt).split(' ').last,
    ].join(' · ');
    return ListTile(
      leading: CategoryAvatar(v.category),
      title: Text(t.merchant, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: AmountText(t.amountMinor, t.currency, v.type),
      onTap: () => context.push('/txn/${t.id}'),
    );
  }
}

class _MenuChip<T> extends StatelessWidget {
  const _MenuChip({required this.label, required this.selected, required this.options, required this.onSelected});
  final String label;
  final bool selected;
  final Map<T, String> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    // Items are addressed by index so a `null` option ("all") is selectable.
    child: PopupMenuButton<int>(
      itemBuilder: (_) => [for (final (i, e) in options.entries.indexed) PopupMenuItem(value: i, child: Text(e.value))],
      onSelected: (i) => onSelected(options.keys.elementAt(i)),
      child: Chip(
        label: Text(label),
        avatar: const Icon(Icons.arrow_drop_down, size: 18),
        backgroundColor: selected ? Theme.of(context).colorScheme.secondaryContainer : null,
      ),
    ),
  );
}
