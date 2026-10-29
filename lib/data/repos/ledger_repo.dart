import 'package:cg_core/cg_core.dart';
import 'package:drift/drift.dart';

import '../db/database.dart';

class TxnView {
  const TxnView(this.txn, this.card, this.category);
  final TxnRow txn;
  final CardRow card;
  final CategoryRow? category;

  TxnType get type => TxnType.fromName(txn.type);
}

class TxnFilter {
  const TxnFilter({this.cardId, this.categoryId, this.type, this.query, this.from, this.to, this.limit = 500});
  final int? cardId;
  final int? categoryId;
  final TxnType? type;
  final String? query;
  final DateTime? from;
  final DateTime? to;
  final int limit;

  TxnFilter copyWithCard(int? cardId) =>
      TxnFilter(cardId: cardId, categoryId: categoryId, type: type, query: query, from: from, to: to, limit: limit);
}

enum InsertOutcome { inserted, duplicate }

class InsertResult {
  const InsertResult(this.outcome, [this.id]);
  final InsertOutcome outcome;
  final int? id;
}

class CategoryTotal {
  const CategoryTotal(this.category, this.minor);
  final CategoryRow? category;
  final int minor;
}

class MerchantTotal {
  const MerchantTotal(this.merchant, this.minor, this.count);
  final String merchant;
  final int minor;
  final int count;
}

/// Spending for one month. Amounts are in [currency]; other currencies are
/// listed in [otherCurrencies] and not mixed in.
class MonthSummary {
  const MonthSummary({
    required this.currency,
    required this.spendMinor,
    required this.refundsMinor,
    required this.paymentsMinor,
    required this.count,
    required this.byCategory,
    required this.topMerchants,
    required this.dailySpend,
    required this.otherCurrencies,
  });

  final String currency;
  final int spendMinor;
  final int refundsMinor;
  final int paymentsMinor;
  final int count;
  final List<CategoryTotal> byCategory;
  final List<MerchantTotal> topMerchants;

  /// Net spend per day of month, index 0 = day 1.
  final List<int> dailySpend;
  final Map<String, int> otherCurrencies;
}

class DueItem {
  const DueItem(this.card, this.dueDate, this.amountMinor, this.currency, {this.statement, this.estimated = false});
  final CardRow card;
  final DateTime dueDate;
  final int? amountMinor;
  final String currency;
  final StatementRow? statement;

  /// True when derived from the card's due day because no statement exists.
  final bool estimated;
}

class InstallmentView {
  const InstallmentView(this.row, this.card, this.paidMonths);
  final InstallmentRow row;
  final CardRow card;
  final int paidMonths;
  int get remainingMonths => (row.months - paidMonths).clamp(0, row.months);
  int get remainingMinor => remainingMonths * row.monthlyMinor;
}

class LedgerRepo {
  LedgerRepo(this.db);
  final AppDatabase db;

  // ---------------------------------------------------------------- cards

  Stream<List<CardRow>> watchCards({bool includeArchived = false}) {
    final q = db.select(db.cards)..orderBy([(c) => OrderingTerm.asc(c.createdAt)]);
    if (!includeArchived) q.where((c) => c.archived.equals(false));
    return q.watch();
  }

  Future<List<CardRow>> cards() => (db.select(db.cards)..where((c) => c.archived.equals(false))).get();

  Stream<CardRow?> watchCard(int id) => (db.select(db.cards)..where((c) => c.id.equals(id))).watchSingleOrNull();

  /// Finds or creates the card a transaction belongs to.
  Future<int> ensureCard(String bankCode, String last4, {String currency = 'EGP'}) async {
    final existing = await (db.select(
      db.cards,
    )..where((c) => c.bankCode.equals(bankCode) & c.last4.equals(last4))).getSingleOrNull();
    if (existing != null) return existing.id;
    return db.into(db.cards).insert(CardsCompanion.insert(bankCode: bankCode, last4: last4, currency: Value(currency)));
  }

  Future<void> updateCard(CardsCompanion c) => (db.update(db.cards)..where((t) => t.id.equals(c.id.value))).write(c);

  Future<void> deleteCard(int id) => (db.delete(db.cards)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------- transactions

  /// Stores a parsed transaction. Returns [InsertOutcome.duplicate] when the
  /// same alert was already stored (by any source).
  Future<InsertResult> insertParsed(ParsedTransaction t, SourceType source, {List<MerchantRule>? userRules}) async {
    return db.transaction(() async {
      final hash = transactionHash(t);
      final dup = await (db.select(db.transactions)..where((x) => x.sourceHash.equals(hash))).getSingleOrNull();
      if (dup != null) return InsertResult(InsertOutcome.duplicate, dup.id);

      final cardId = await ensureCard(t.bankCode, t.last4, currency: t.availableLimitCurrency ?? t.currency);
      final categoryId = await _categoryFor(t.merchant, t.type, userRules: userRules);
      final id = await db
          .into(db.transactions)
          .insert(
            TransactionsCompanion.insert(
              cardId: cardId,
              type: t.type.name,
              amountMinor: t.amountMinor,
              currency: t.currency,
              originalAmountMinor: Value(t.originalAmountMinor),
              originalCurrency: Value(t.originalCurrency),
              merchant: t.merchant,
              categoryId: Value(categoryId),
              occurredAt: t.occurredAt,
              availableLimitMinor: Value(t.availableLimitMinor),
              sourceType: source.name,
              sourceHash: hash,
              parserId: t.parserId,
              parserVersion: t.parserVersion,
            ),
          );

      if (t.availableLimitMinor != null) {
        final card = await (db.select(db.cards)..where((c) => c.id.equals(cardId))).getSingle();
        if (card.lastAvailableAt == null || !t.occurredAt.isBefore(card.lastAvailableAt!)) {
          await (db.update(db.cards)..where((c) => c.id.equals(cardId))).write(
            CardsCompanion(
              lastAvailableMinor: Value(t.availableLimitMinor),
              lastAvailableCurrency: Value(t.availableLimitCurrency),
              lastAvailableAt: Value(t.occurredAt),
            ),
          );
        }
      }
      return InsertResult(InsertOutcome.inserted, id);
    });
  }

  Future<int?> _categoryFor(String merchant, TxnType type, {List<MerchantRule>? userRules}) async {
    final rules = userRules ?? await userMerchantRules();
    String? key;
    if (type == TxnType.fee || type == TxnType.interest) {
      key = CategoryKeys.fees;
    } else {
      key = categorize(merchant, userRules: rules);
    }
    if (key == null) return null;
    final cat = await (db.select(db.categories)..where((c) => c.key.equals(key!))).getSingleOrNull();
    return cat?.id;
  }

  /// Which of [hashes] are already stored (to flag duplicates in previews).
  Future<Set<String>> existingHashes(Iterable<String> hashes) async {
    final list = hashes.toSet().toList();
    final found = <String>{};
    for (var i = 0; i < list.length; i += 500) {
      final chunk = list.sublist(i, (i + 500).clamp(0, list.length));
      final rows =
          await (db.selectOnly(db.transactions)
                ..addColumns([db.transactions.sourceHash])
                ..where(db.transactions.sourceHash.isIn(chunk)))
              .get();
      found.addAll(rows.map((r) => r.read(db.transactions.sourceHash)!));
    }
    return found;
  }

  Future<void> updateTransaction(TransactionsCompanion c) => (db.update(
    db.transactions,
  )..where((t) => t.id.equals(c.id.value))).write(c.copyWith(updatedAt: Value(DateTime.now())));

  Future<void> deleteTransaction(int id) => (db.delete(db.transactions)..where((t) => t.id.equals(id))).go();

  Stream<List<TxnView>> watchTransactions(TxnFilter f) {
    final q = db.select(db.transactions).join([
      innerJoin(db.cards, db.cards.id.equalsExp(db.transactions.cardId)),
      leftOuterJoin(db.categories, db.categories.id.equalsExp(db.transactions.categoryId)),
    ]);
    if (f.cardId != null) q.where(db.transactions.cardId.equals(f.cardId!));
    if (f.categoryId != null) q.where(db.transactions.categoryId.equals(f.categoryId!));
    if (f.type != null) q.where(db.transactions.type.equals(f.type!.name));
    if (f.from != null) q.where(db.transactions.occurredAt.isBiggerOrEqualValue(f.from!));
    if (f.to != null) q.where(db.transactions.occurredAt.isSmallerThanValue(f.to!));
    final query = f.query?.trim();
    if (query != null && query.isNotEmpty) {
      q.where(db.transactions.merchant.like('%${_escapeLike(query)}%', escapeChar: r'\'));
    }
    q
      ..orderBy([OrderingTerm.desc(db.transactions.occurredAt), OrderingTerm.desc(db.transactions.id)])
      ..limit(f.limit);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          TxnView(r.readTable(db.transactions), r.readTable(db.cards), r.readTableOrNull(db.categories)),
      ],
    );
  }

  Future<TxnView?> transaction(int id) async {
    final q = db.select(db.transactions).join([
      innerJoin(db.cards, db.cards.id.equalsExp(db.transactions.cardId)),
      leftOuterJoin(db.categories, db.categories.id.equalsExp(db.transactions.categoryId)),
    ])..where(db.transactions.id.equals(id));
    final r = await q.getSingleOrNull();
    if (r == null) return null;
    return TxnView(r.readTable(db.transactions), r.readTable(db.cards), r.readTableOrNull(db.categories));
  }

  static String _escapeLike(String s) => s.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');

  /// Spending summary for the month containing [month].
  Stream<MonthSummary> watchMonth(DateTime month, {int? cardId}) {
    final from = DateTime(month.year, month.month);
    final to = DateTime(month.year, month.month + 1);
    return watchTransactions(TxnFilter(cardId: cardId, from: from, to: to, limit: 100000)).map((list) {
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final counted = list.where((v) => v.type != TxnType.declined).toList();
      // The currency with the most transactions is the headline currency.
      final freq = <String, int>{};
      for (final v in counted) {
        freq[v.txn.currency] = (freq[v.txn.currency] ?? 0) + 1;
      }
      final currency = freq.isEmpty ? 'EGP' : (freq.entries.toList()..sort((a, b) => b.value - a.value)).first.key;

      var spend = 0, refunds = 0, payments = 0;
      final byCat = <int?, (CategoryRow?, int)>{};
      final byMerchant = <String, (String, int, int)>{};
      final daily = List<int>.filled(daysInMonth, 0);
      final others = <String, int>{};
      for (final v in counted) {
        final t = v.txn;
        final sign = v.type.spendSign;
        if (t.currency != currency) {
          others[t.currency] = (others[t.currency] ?? 0) + sign * t.amountMinor;
          continue;
        }
        if (v.type == TxnType.payment) payments += t.amountMinor;
        if (sign < 0) refunds += t.amountMinor;
        if (sign == 0) continue;
        final signed = sign * t.amountMinor;
        spend += signed;
        final c = byCat[t.categoryId];
        byCat[t.categoryId] = (v.category, (c?.$2 ?? 0) + signed);
        final key = normalizeMerchant(t.merchant);
        final m = byMerchant[key];
        byMerchant[key] = (m?.$1 ?? t.merchant, (m?.$2 ?? 0) + signed, (m?.$3 ?? 0) + 1);
        daily[t.occurredAt.day - 1] += signed;
      }
      final cats = [for (final e in byCat.values) CategoryTotal(e.$1, e.$2)]
        ..removeWhere((c) => c.minor <= 0)
        ..sort((a, b) => b.minor - a.minor);
      final merchants = [for (final e in byMerchant.values) MerchantTotal(e.$1, e.$2, e.$3)]
        ..sort((a, b) => b.minor - a.minor);
      return MonthSummary(
        currency: currency,
        spendMinor: spend,
        refundsMinor: refunds,
        paymentsMinor: payments,
        count: counted.length,
        byCategory: cats,
        topMerchants: merchants.take(5).toList(),
        dailySpend: daily,
        otherCurrencies: others..removeWhere((_, v) => v == 0),
      );
    });
  }

  /// Net spend per month for the last [months] months, oldest first, in [currency].
  Future<List<(DateTime, int)>> monthlyTrend(String currency, {int months = 6, int? cardId}) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - months + 1);
    final rows = await watchTransactions(TxnFilter(cardId: cardId, from: start, limit: 1000000)).first;
    final totals = <int, int>{};
    for (final v in rows) {
      if (v.txn.currency != currency) continue;
      final k = v.txn.occurredAt.year * 12 + v.txn.occurredAt.month - 1;
      totals[k] = (totals[k] ?? 0) + v.type.spendSign * v.txn.amountMinor;
    }
    return [
      for (var i = 0; i < months; i++)
        () {
          final d = DateTime(start.year, start.month + i);
          return (d, totals[d.year * 12 + d.month - 1] ?? 0);
        }(),
    ];
  }

  // ------------------------------------------------------------ categories

  Stream<List<CategoryRow>> watchCategories() =>
      (db.select(db.categories)..orderBy([(c) => OrderingTerm.asc(c.id)])).watch();

  Future<List<MerchantRule>> userMerchantRules() async {
    final q = db.select(db.merchantRules).join([
      innerJoin(db.categories, db.categories.id.equalsExp(db.merchantRules.categoryId)),
    ]);
    return [
      for (final r in await q.get())
        MerchantRule(r.readTable(db.merchantRules).pattern, r.readTable(db.categories).key),
    ];
  }

  Future<int> addCategory(String nameEn, String nameAr, int icon, int color) => db
      .into(db.categories)
      .insert(
        CategoriesCompanion.insert(
          key: 'custom_${DateTime.now().microsecondsSinceEpoch}',
          nameEn: nameEn,
          nameAr: nameAr,
          icon: icon,
          color: color,
        ),
      );

  /// Sets a transaction's category. With [rememberMerchant], all past and
  /// future transactions from the same merchant get it too.
  Future<void> setCategory(int txnId, int? categoryId, {bool rememberMerchant = false}) async {
    await db.transaction(() async {
      final t = await (db.select(db.transactions)..where((x) => x.id.equals(txnId))).getSingle();
      await (db.update(db.transactions)..where((x) => x.id.equals(txnId))).write(
        TransactionsCompanion(categoryId: Value(categoryId), updatedAt: Value(DateTime.now())),
      );
      if (rememberMerchant && categoryId != null) {
        final pattern = normalizeMerchant(t.merchant);
        await db
            .into(db.merchantRules)
            .insertOnConflictUpdate(MerchantRulesCompanion.insert(pattern: pattern, categoryId: categoryId));
        await (db.update(db.transactions)..where((x) => x.merchant.upper().equals(pattern))).write(
          TransactionsCompanion(categoryId: Value(categoryId)),
        );
      }
    });
  }

  // ------------------------------------------------- statements & installments

  Stream<List<StatementRow>> watchStatements(int cardId) =>
      (db.select(db.statements)
            ..where((s) => s.cardId.equals(cardId))
            ..orderBy([(s) => OrderingTerm.desc(s.dueDate)]))
          .watch();

  Future<int> addStatement(StatementsCompanion s) => db.into(db.statements).insert(s);

  Future<void> setStatementPaid(int id, bool paid) =>
      (db.update(db.statements)..where((s) => s.id.equals(id))).write(StatementsCompanion(paid: Value(paid)));

  Future<void> deleteStatement(int id) => (db.delete(db.statements)..where((s) => s.id.equals(id))).go();

  /// Upcoming dues: unpaid statements, plus an estimate from the card's due
  /// day for cards that have no unpaid statement.
  Stream<List<DueItem>> watchUpcomingDues() {
    final q = db.select(db.cards).join([
      leftOuterJoin(db.statements, db.statements.cardId.equalsExp(db.cards.id) & db.statements.paid.equals(false)),
    ])..where(db.cards.archived.equals(false));
    return q.watch().map((rows) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final items = <DueItem>[];
      final withStatement = <int>{};
      for (final r in rows) {
        final card = r.readTable(db.cards);
        final s = r.readTableOrNull(db.statements);
        if (s != null) {
          withStatement.add(card.id);
          items.add(DueItem(card, s.dueDate, s.totalDueMinor, s.currency, statement: s));
        }
      }
      for (final r in rows) {
        final card = r.readTable(db.cards);
        if (withStatement.contains(card.id) || card.dueDay == null) continue;
        if (items.any((i) => i.card.id == card.id)) continue;
        var due = DateTime(today.year, today.month, card.dueDay!.clamp(1, 28));
        if (due.isBefore(today)) due = DateTime(today.year, today.month + 1, card.dueDay!.clamp(1, 28));
        items.add(DueItem(card, due, null, card.currency, estimated: true));
      }
      items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return items;
    });
  }

  Stream<List<InstallmentView>> watchInstallments({int? cardId}) {
    final q = db.select(db.installments).join([innerJoin(db.cards, db.cards.id.equalsExp(db.installments.cardId))]);
    if (cardId != null) q.where(db.installments.cardId.equals(cardId));
    return q.watch().map((rows) {
      final now = DateTime.now();
      return [
        for (final r in rows)
          () {
            final i = r.readTable(db.installments);
            final elapsed = (now.year - i.startDate.year) * 12 + now.month - i.startDate.month + 1;
            return InstallmentView(i, r.readTable(db.cards), elapsed.clamp(0, i.months));
          }(),
      ]..sort((a, b) => b.remainingMinor - a.remainingMinor);
    });
  }

  Future<int> addInstallment(InstallmentsCompanion i) => db.into(db.installments).insert(i);

  Future<void> deleteInstallment(int id) => (db.delete(db.installments)..where((s) => s.id.equals(id))).go();
}
