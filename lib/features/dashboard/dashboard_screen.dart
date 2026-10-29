import 'dart:math';

import 'package:cg_core/cg_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../data/repos/ledger_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final month = ref.watch(selectedMonthProvider);
    final summary = ref.watch(monthSummaryProvider);
    final cards = ref.watch(cardsProvider).value ?? const [];
    final dues = ref.watch(duesProvider).value ?? const [];
    final now = DateTime.now();
    final isCurrentMonth = month.year == now.year && month.month == now.month;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: l.previousMonth,
              onPressed: () => ref.read(selectedMonthProvider.notifier).shift(-1),
            ),
            Flexible(child: Text(formatMonth(context, month), overflow: TextOverflow.ellipsis)),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: l.nextMonth,
              onPressed: isCurrentMonth ? null : () => ref.read(selectedMonthProvider.notifier).shift(1),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-dashboard',
        tooltip: l.addTransaction,
        onPressed: () => context.push('/txn/new'),
        child: const Icon(Icons.add),
      ),
      body: cards.isEmpty
          ? EmptyState(
              icon: Icons.credit_card_outlined,
              title: l.noCardsTitle,
              message: l.noCardsMessage,
              action: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.tonal(onPressed: () => context.push('/sources'), child: Text(l.sourcesTitle)),
                  FilledButton(onPressed: () => context.push('/import/paste'), child: Text(l.pasteImportTitle)),
                ],
              ),
            )
          : summary.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (s) => ListView(
                padding: const EdgeInsets.only(bottom: 96),
                children: [
                  Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: _SpendCard(s)),
                  SectionTitle(l.cardsTitle),
                  SizedBox(
                    height: 132,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: cards.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (c, i) => _CardTile(cards[i]),
                    ),
                  ),
                  if (dues.isNotEmpty) ...[SectionTitle(l.upcomingDues), for (final d in dues.take(3)) _DueTile(d)],
                  if (s.byCategory.isNotEmpty) ...[SectionTitle(l.byCategory), _CategoryChart(s)],
                  if (s.spendMinor > 0) ...[SectionTitle(l.dailySpending), _DailyChart(s)],
                  if (s.topMerchants.isNotEmpty) ...[
                    SectionTitle(l.topMerchants),
                    for (final m in s.topMerchants)
                      ListTile(
                        dense: true,
                        title: Text(m.merchant, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(l.transactionsCount(m.count)),
                        trailing: Text(formatMoney(m.minor, s.currency), textDirection: TextDirection.ltr),
                      ),
                  ],
                  if (s.count == 0) EmptyState(icon: Icons.insights_outlined, title: l.noSpendingThisMonth),
                ],
              ),
            ),
    );
  }
}

class _SpendCard extends StatelessWidget {
  const _SpendCard(this.s);
  final MonthSummary s;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.spentThisMonth, style: t.labelLarge?.copyWith(color: scheme.onPrimaryContainer)),
            const SizedBox(height: 4),
            Text(
              formatMoney(s.spendMinor, s.currency),
              textDirection: TextDirection.ltr,
              style: t.headlineMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Text(l.transactionsCount(s.count), style: t.bodySmall?.copyWith(color: scheme.onPrimaryContainer)),
                if (s.refundsMinor > 0)
                  Text(
                    l.refundsAmount(formatMoney(s.refundsMinor, s.currency)),
                    style: t.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                  ),
                if (s.paymentsMinor > 0)
                  Text(
                    l.paymentsAmount(formatMoney(s.paymentsMinor, s.currency)),
                    style: t.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                  ),
                for (final e in s.otherCurrencies.entries)
                  Text(
                    '+ ${formatMoney(e.value, e.key)}',
                    textDirection: TextDirection.ltr,
                    style: t.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile(this.card);
  final CardRow card;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final available = card.lastAvailableMinor;
    final limit = card.creditLimitMinor;
    final used = (available != null && limit != null && limit > 0) ? 1 - available / limit : null;
    return SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/cards/${card.id}'),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.credit_card, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(cardLabel(context, card), style: t.titleSmall, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const Spacer(),
                Text(l.availableLimit, style: t.labelSmall),
                Text(
                  available == null ? '—' : formatMoney(available, card.lastAvailableCurrency ?? card.currency),
                  textDirection: TextDirection.ltr,
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (used != null) ...[
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: used.clamp(0, 1).toDouble(), borderRadius: BorderRadius.circular(4)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DueTile extends StatelessWidget {
  const _DueTile(this.d);
  final DueItem d;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final days = DateTime(
      d.dueDate.year,
      d.dueDate.month,
      d.dueDate.day,
    ).difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inDays;
    final overdue = days < 0;
    return ListTile(
      leading: Icon(
        overdue ? Icons.error_outline : Icons.event_outlined,
        color: overdue || days <= 3 ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(cardLabel(context, d.card)),
      subtitle: Text(
        '${formatDate(context, d.dueDate)} · ${overdue ? l.overdue : l.inDays(days)}${d.estimated ? ' · ${l.estimated}' : ''}',
      ),
      trailing: d.amountMinor == null
          ? null
          : Text(formatMoney(d.amountMinor!, d.currency), textDirection: TextDirection.ltr),
      onTap: () => context.push('/cards/${d.card.id}'),
    );
  }
}

class _CategoryChart extends StatelessWidget {
  const _CategoryChart(this.s);
  final MonthSummary s;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final total = s.byCategory.fold<int>(0, (a, c) => a + c.minor);
    final outline = Theme.of(context).colorScheme.outline;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 36,
                sections: [
                  for (final c in s.byCategory)
                    PieChartSectionData(
                      value: c.minor.toDouble(),
                      color: c.category == null ? outline : Color(c.category!.color),
                      radius: 28,
                      showTitle: false,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                for (final c in s.byCategory.take(6))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: c.category == null ? outline : Color(c.category!.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c.category == null ? l.uncategorized : categoryName(context, c.category!),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('${(100 * c.minor / max(total, 1)).round()}%'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyChart extends StatelessWidget {
  const _DailyChart(this.s);
  final MonthSummary s;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final exp = pow(10, currencyExponent(s.currency)).toInt();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: SizedBox(
        height: 160,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (v, meta) {
                      final day = v.toInt() + 1;
                      if (day != 1 && day % 5 != 0) return const SizedBox();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text('$day', style: Theme.of(context).textTheme.labelSmall),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                    '${group.x + 1}: ${formatMoney((rod.toY * exp).round(), s.currency)}',
                    TextStyle(color: scheme.onInverseSurface),
                  ),
                  getTooltipColor: (_) => scheme.inverseSurface,
                ),
              ),
              barGroups: [
                for (var i = 0; i < s.dailySpend.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: max(0, s.dailySpend[i]) / exp,
                        color: scheme.primary,
                        width: 6,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
