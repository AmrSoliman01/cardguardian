import 'dart:math';
import 'dart:typed_data';

import 'package:cg_core/cg_core.dart';
import 'package:drift/drift.dart' show OrderingTerm;

import '../data/db/database.dart';
import '../data/repos/ledger_repo.dart';
import 'xlsx_writer.dart';

/// Exports to the "credit card payment import template" workbook: sheets
/// Read me, Lists, Statements, Payments and Purchases, same columns, header
/// rows and dropdowns, with the app's data from row 3.
class ExcelExportService {
  ExcelExportService(this.db, this.ledger);
  final AppDatabase db;
  final LedgerRepo ledger;

  static const categories = [
    'Groceries',
    'Dining',
    'Fuel',
    'Shopping',
    'Travel',
    'Bills & utilities',
    'Health',
    'Education',
    'Entertainment',
    'Online',
    'Electronics',
    'Cash withdrawal',
    'Other',
  ];
  static const feeTypes = [
    'Markup fee',
    'Foreign transaction fee',
    'Cash withdrawal fee',
    'Installment fee',
    'Service fee',
    'Late payment fee',
    'Interest',
    'Other fee',
  ];

  static const _categoryMap = {
    CategoryKeys.groceries: 'Groceries',
    CategoryKeys.dining: 'Dining',
    CategoryKeys.transport: 'Travel',
    CategoryKeys.shopping: 'Shopping',
    CategoryKeys.bills: 'Bills & utilities',
    CategoryKeys.subscriptions: 'Online',
    CategoryKeys.health: 'Health',
    CategoryKeys.travel: 'Travel',
    CategoryKeys.entertainment: 'Entertainment',
    CategoryKeys.fuel: 'Fuel',
    CategoryKeys.education: 'Education',
    CategoryKeys.fees: 'Other',
    CategoryKeys.other: 'Other',
  };

  /// Types exported as purchases. Refunds, reversals and declined charges
  /// have no place in the template and are left out (see [ExcelExportResult]).
  static const _purchaseTypes = {
    TxnType.purchase,
    TxnType.cashWithdrawal,
    TxnType.installment,
    TxnType.fee,
    TxnType.interest,
  };

  /// The name used in the "Card nickname" column: the card's nickname, or
  /// `paidBy bank` (plus the last 4 digits when two cards share a bank).
  static String cardNickname(CardRow c, List<CardRow> all, String paidBy) {
    final nick = c.nickname?.trim();
    if (nick != null && nick.isNotEmpty) return nick;
    final bank = c.bankCode.split('_').first;
    final shared = all.where((o) => o.bankCode == c.bankCode).length > 1;
    return [if (paidBy.trim().isNotEmpty) paidBy.trim(), bank, if (shared) c.last4].join(' ');
  }

  static String categoryFor(TxnView v) {
    if (v.type == TxnType.cashWithdrawal) return 'Cash withdrawal';
    return _categoryMap[v.category?.key] ?? 'Other';
  }

  static num _amount(int minor, String currency) {
    final exp = currencyExponent(currency);
    final unit = pow(10, exp).toInt();
    return minor % unit == 0 ? minor ~/ unit : minor / unit;
  }

  Future<ExcelExportResult> build({required String paidBy}) async {
    final cards = await db.select(db.cards).get();
    final names = {for (final c in cards) c.id: cardNickname(c, cards, paidBy)};
    final statements = await (db.select(db.statements)..orderBy([(s) => OrderingTerm.asc(s.periodEnd)])).get();
    final txns = (await ledger.watchTransactions(const TxnFilter(limit: 1 << 30)).first).reversed.toList();

    final wb = XlsxWorkbook();
    _readMe(wb.sheet('Read me - اقرأني'));
    _lists(wb.sheet('Lists'), names.values.toSet().toList()..sort());
    final cardList =
        r'Lists!$A$2:$A$'
        '${1 + (names.isEmpty ? 1 : names.values.toSet().length)}';

    // Statements
    final st = wb.sheet('Statements - الكشوف', freezeRows: 2);
    _header(
      st,
      const [
        ('Card nickname * / الاسم المميز للبطاقة', true, 'Pick from the list (as in Credit cards)'),
        ('Statement month * / شهر الكشف', true, '1 – 12'),
        ('Statement year * / سنة الكشف', true, 'e.g. 2026'),
        ('Statement amount * / مبلغ الكشف', true, 'Number, e.g. 12500.50'),
        ('Due date * / تاريخ الاستحقاق', true, 'Date, e.g. 2026-09-15'),
        ('Issue date / تاريخ الإصدار', false, 'Date, e.g. 2026-09-15'),
        ('Minimum payment / الحد الأدنى للسداد', false, 'Number, e.g. 12500.50'),
        ('Statement number / رقم الكشف', false, 'Text (optional)'),
        ('Notes / ملاحظات', false, 'Text (optional)'),
      ],
      const {0: 26, 1: 14, 3: 16, 4: 16, 6: 16, 7: 18, 8: 30},
    );
    st.validations.add(XValidation('A3:A2000', cardList));
    for (final s in statements) {
      st.add([
        XCell.text(names[s.cardId] ?? ''),
        XCell.number(s.periodEnd.month),
        XCell.number(s.periodEnd.year),
        XCell.number(_amount(s.totalDueMinor, s.currency)),
        XCell.date(s.dueDate),
        XCell.date(s.periodEnd),
        s.minimumDueMinor == null ? null : XCell.number(_amount(s.minimumDueMinor!, s.currency)),
      ]);
    }

    // Payments
    final pay = wb.sheet('Payments - الدفعات', freezeRows: 2);
    _header(
      pay,
      const [
        ('Card nickname * / الاسم المميز للبطاقة', true, 'Pick from the list (as in Credit cards)'),
        ('Statement month * / شهر الكشف', true, '1 – 12'),
        ('Statement year * / سنة الكشف', true, 'e.g. 2026'),
        ('Payment date * / تاريخ الدفع', true, 'Date, e.g. 2026-09-15'),
        ('Amount * / المبلغ', true, 'Number, e.g. 12500.50'),
        ('Paid by * / الدافع', true, 'Text'),
        ('Payment source / مصدر الدفع', false, 'Text (optional)'),
        ('Notes / ملاحظات', false, 'Text (optional)'),
      ],
      const {0: 26, 1: 14, 3: 16, 4: 16, 5: 18, 7: 30},
    );
    pay.validations.add(XValidation('A3:A2000', cardList));

    // Purchases
    final pur = wb.sheet('Purchases - المشتريات', freezeRows: 2);
    _header(
      pur,
      const [
        ('Card nickname * / الاسم المميز للبطاقة', true, 'Pick from the list (as in Credit cards)'),
        ('Purchase date * / تاريخ الشراء', true, 'Date, e.g. 2026-09-15'),
        ('Merchant * / التاجر', true, 'Text'),
        ('Category / التصنيف', false, 'Pick from the list'),
        ('Amount * / المبلغ', true, 'Number, e.g. 12500.50'),
        (
          'Amount includes fees? / المبلغ شامل الرسوم؟',
          false,
          'yes = total as on the statement; empty/no = before fees',
        ),
        ('Statement month / شهر الكشف', false, '1 – 12'),
        ('Statement year / سنة الكشف', false, 'e.g. 2026'),
        ('Original amount (foreign) / المبلغ بالعملة الأجنبية', false, 'Number, e.g. 12500.50'),
        ('Currency / العملة', false, 'e.g. USD'),
        ('Notes / ملاحظات', false, 'Text (optional)'),
        ('Fee 1 type / نوع الرسوم 1', false, 'Pick from the list'),
        ('Fee 1 calculation / حساب الرسوم 1', false, 'amount or percent'),
        ('Fee 1 value / قيمة الرسوم 1', false, 'Amount, or % e.g. 2.5'),
        ('Fee 2 type / نوع الرسوم 2', false, 'Pick from the list'),
        ('Fee 2 calculation / حساب الرسوم 2', false, 'amount or percent'),
        ('Fee 2 value / قيمة الرسوم 2', false, 'Amount, or % e.g. 2.5'),
        ('Fee 3 type / نوع الرسوم 3', false, 'Pick from the list'),
        ('Fee 3 calculation / حساب الرسوم 3', false, 'amount or percent'),
        ('Fee 3 value / قيمة الرسوم 3', false, 'Amount, or % e.g. 2.5'),
      ],
      const {
        0: 26,
        1: 16,
        2: 22,
        3: 20,
        4: 16,
        5: 18,
        6: 14,
        8: 16,
        9: 10,
        10: 30,
        11: 22,
        12: 16,
        14: 22,
        15: 16,
        17: 22,
        18: 16,
      },
    );
    pur.validations.addAll([
      XValidation('A3:A2000', cardList),
      const XValidation(r'D3:D2000', r'Lists!$B$2:$B$14'),
      const XValidation(r'F3:F2000', r'Lists!$E$2:$E$3'),
      for (final col in const ['L', 'O', 'R']) XValidation('${col}3:${col}2000', r'Lists!$C$2:$C$9'),
      for (final col in const ['M', 'P', 'S']) XValidation('${col}3:${col}2000', r'Lists!$D$2:$D$3'),
    ]);

    final result = ExcelExportResult();
    for (final v in txns) {
      final t = v.txn;
      final name = names[t.cardId] ?? '';
      if (v.type == TxnType.payment) {
        final s = statementFor(statements, t.cardId, t.occurredAt);
        final month = s?.periodEnd ?? DateTime(t.occurredAt.year, t.occurredAt.month - 1);
        pay.add([
          XCell.text(name),
          XCell.number(month.month),
          XCell.number(month.year),
          XCell.date(t.occurredAt),
          XCell.number(_amount(t.amountMinor, t.currency)),
          XCell.text(paidBy),
          null,
          if (t.note != null) XCell.text(t.note!),
        ]);
        result.payments++;
      } else if (_purchaseTypes.contains(v.type)) {
        final foreign = t.currency != v.card.currency;
        final notes = [
          if (foreign) 'Amount in ${v.card.currency} not in the SMS',
          if (t.note != null && t.note!.trim().isNotEmpty) t.note!.trim(),
        ].join(' · ');
        pur.add([
          XCell.text(name),
          XCell.date(t.occurredAt),
          XCell.text(t.merchant),
          XCell.text(categoryFor(v)),
          foreign ? null : XCell.number(_amount(t.amountMinor, t.currency)),
          null,
          null,
          null,
          foreign ? XCell.number(_amount(t.amountMinor, t.currency)) : null,
          foreign ? XCell.text(t.currency) : null,
          notes.isEmpty ? null : XCell.text(notes),
        ]);
        result.purchases++;
        if (foreign) result.foreignWithoutLocalAmount++;
      } else {
        result.skipped++;
      }
    }
    result.statements = statements.length;
    result.bytes = wb.encode();
    return result;
  }

  /// The statement a payment settles: the card's latest statement issued on
  /// or before the payment date.
  static StatementRow? statementFor(List<StatementRow> sorted, int cardId, DateTime paidAt) {
    StatementRow? found;
    for (final s in sorted) {
      if (s.cardId == cardId && !s.periodEnd.isAfter(paidAt)) found = s;
    }
    return found;
  }

  void _header(XSheet s, List<(String, bool, String)> cols, Map<int, double> widths) {
    s.add([for (final c in cols) XCell.text(c.$1, c.$2 ? XStyle.headerRequired : XStyle.headerOptional)]);
    s.add([for (final c in cols) XCell.text(c.$3, XStyle.hint)]);
    s.rowHeights[0] = 36;
    s.rowHeights[1] = 30;
    s.colWidths.addAll(widths);
  }

  void _lists(XSheet s, List<String> cards) {
    const fee = ['amount', 'percent'];
    const yn = ['yes', 'no'];
    s.add([
      const XCell.text('cards'),
      const XCell.text('categories'),
      const XCell.text('feeTypes'),
      const XCell.text('feeCalc'),
      const XCell.text('yesNo'),
    ]);
    final n = [cards.length, categories.length, feeTypes.length, 2].reduce((a, b) => a > b ? a : b);
    for (var i = 0; i < n; i++) {
      s.add([
        i < cards.length ? XCell.text(cards[i]) : null,
        i < categories.length ? XCell.text(categories[i]) : null,
        i < feeTypes.length ? XCell.text(feeTypes[i]) : null,
        i < 2 ? XCell.text(fee[i]) : null,
        i < 2 ? XCell.text(yn[i]) : null,
      ]);
    }
  }

  void _readMe(XSheet s) {
    s.colWidths[0] = 110;
    XCell w(String t) => XCell.text(t, XStyle.wrap);
    s
      ..add([const XCell.text('How to fill in this template', XStyle.title)])
      ..add([])
      ..add([
        w(
          '1. Use one sheet per type: Statements, Payments, Purchases. Fill from row 3 (row 1 = column names, row 2 = '
          'format hints). Leave sheets you do not need empty.',
        ),
      ])
      ..add([
        w(
          '2. Columns marked * are required. Card nickname must match a card in the app exactly (pick it from the '
          'dropdown).',
        ),
      ])
      ..add([w('3. Dates: 2026-09-15 or 15/09/2026, or Excel dates. Amounts: plain numbers, no currency sign.')])
      ..add([
        w(
          '4. Payments and linked purchases point to a statement by card + statement month + statement year. The '
          'statement can be in this file or already in the app.',
        ),
      ])
      ..add([
        w(
          "5. Purchases: up to 3 fees each. Fee calculation is 'amount' (a fixed value) or 'percent' (e.g. 2.5). "
          "'Amount includes fees?' = yes when the amount is the total charged as on the statement.",
        ),
      ])
      ..add([
        w('6. Upload the file on the Import page. You will see every row with its errors before anything is saved.'),
      ])
      ..add([])
      ..add([const XCell.text('Exported by CardGuardian', XStyle.bold)])
      ..add([
        w(
          'Rows from row 3 on each sheet come from CardGuardian. Card nicknames are the names set in CardGuardian → '
          'Cards; edit them there (or here) so they match your cards exactly. Refunds and reversals are not exported. '
          'Foreign-currency purchases have the original amount and currency filled, and the local amount empty.',
        ),
      ]);
  }
}

class ExcelExportResult {
  int statements = 0;
  int payments = 0;
  int purchases = 0;
  int skipped = 0;
  int foreignWithoutLocalAmount = 0;
  Uint8List bytes = Uint8List(0);
}
