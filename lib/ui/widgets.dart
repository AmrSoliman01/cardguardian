import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';

import '../data/db/database.dart';
import '../l10n/app_localizations.dart';
import 'format.dart';

/// Icons for categories; the database stores the index.
const List<IconData> categoryIcons = [
  Icons.local_grocery_store_outlined,
  Icons.restaurant_outlined,
  Icons.directions_car_outlined,
  Icons.shopping_bag_outlined,
  Icons.receipt_long_outlined,
  Icons.autorenew,
  Icons.local_hospital_outlined,
  Icons.flight_outlined,
  Icons.movie_outlined,
  Icons.local_gas_station_outlined,
  Icons.school_outlined,
  Icons.account_balance_outlined,
  Icons.category_outlined,
  Icons.home_outlined,
  Icons.pets_outlined,
  Icons.fitness_center_outlined,
  Icons.card_giftcard_outlined,
  Icons.child_care_outlined,
];

IconData categoryIcon(CategoryRow? c) =>
    c == null ? Icons.help_outline : categoryIcons[c.icon.clamp(0, categoryIcons.length - 1)];

const List<int> categoryColors = [
  0xFF2E7D32,
  0xFFEF6C00,
  0xFF1565C0,
  0xFF8E24AA,
  0xFF00838F,
  0xFF5E35B1,
  0xFFC62828,
  0xFF0277BD,
  0xFFAD1457,
  0xFF6D4C41,
  0xFF3949AB,
  0xFF757575,
];

String txnTypeLabel(AppLocalizations l, TxnType t) => switch (t) {
  TxnType.purchase => l.typePurchase,
  TxnType.refund => l.typeRefund,
  TxnType.payment => l.typePayment,
  TxnType.fee => l.typeFee,
  TxnType.interest => l.typeInterest,
  TxnType.cashWithdrawal => l.typeCash,
  TxnType.installment => l.typeInstallment,
  TxnType.reversal => l.typeReversal,
  TxnType.declined => l.typeDeclined,
};

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar(this.category, {super.key, this.size = 40});
  final CategoryRow? category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = category == null ? Theme.of(context).colorScheme.outline : Color(category!.color);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(size / 3)),
      child: Icon(categoryIcon(category), color: color, size: size * 0.55),
    );
  }
}

/// Signed amount: refunds and payments in green with a minus sign.
class AmountText extends StatelessWidget {
  const AmountText(this.minor, this.currency, this.type, {super.key, this.style});
  final int minor;
  final String currency;
  final TxnType type;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final credit = type.spendSign < 0 || type == TxnType.payment;
    final declined = type == TxnType.declined;
    final text = '${credit ? '−' : ''}${formatMoney(minor, currency)}';
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: (style ?? Theme.of(context).textTheme.titleMedium)?.copyWith(
        color: declined ? scheme.outline : (credit ? Colors.green.shade700 : null),
        decoration: declined ? TextDecoration.lineThrough : null,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.message, this.action});
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(title, style: t.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(message!, style: t.bodyMedium, textAlign: TextAlign.center),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 8, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

Future<bool> confirm(BuildContext context, {required String title, String? message, String? action}) async {
  final l = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(action ?? l.ok)),
      ],
    ),
  );
  return ok ?? false;
}

void showSnack(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));

/// A labelled money input that keeps the value as integer minor units.
int? parseMoneyInput(String text, String currency) => parseAmountToMinor(
  normalizeDigits(text).trim().replaceAll(' ', '').replaceAll('٫', '.').replaceAll('٬', ',').replaceAll('،', ','),
  currency,
);

/// Converts Arabic-Indic and Persian digits to ASCII digits.
String normalizeDigits(String s) {
  final b = StringBuffer();
  for (final r in s.runes) {
    if (r >= 0x0660 && r <= 0x0669) {
      b.writeCharCode(0x30 + r - 0x0660);
    } else if (r >= 0x06F0 && r <= 0x06F9) {
      b.writeCharCode(0x30 + r - 0x06F0);
    } else {
      b.writeCharCode(r);
    }
  }
  return b.toString();
}
