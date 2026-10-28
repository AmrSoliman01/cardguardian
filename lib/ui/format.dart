import 'package:cg_core/cg_core.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/db/database.dart';

/// Money is shown with Western digits in both languages, with the currency
/// code, e.g. "EGP 1,500.00".
String formatMoney(int minor, String currency, {bool showCurrency = true, bool compact = false}) {
  final exp = currencyExponent(currency);
  final whole = minor ~/ _pow10(exp);
  final String number;
  if (compact && minor.abs() >= 100000 * _pow10(exp)) {
    number = NumberFormat.compact(locale: 'en').format(whole);
  } else {
    final f = NumberFormat.decimalPatternDigits(locale: 'en', decimalDigits: exp);
    number = f.format(minor / _pow10(exp));
  }
  return showCurrency ? '$currency $number' : number;
}

int _pow10(int e) {
  var v = 1;
  for (var i = 0; i < e; i++) {
    v *= 10;
  }
  return v;
}

String formatDate(BuildContext context, DateTime d) =>
    DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(d);

String formatDateTime(BuildContext context, DateTime d) {
  final lang = Localizations.localeOf(context).languageCode;
  return '${DateFormat.yMMMd(lang).format(d)} ${DateFormat.Hm(lang).format(d)}';
}

String formatMonth(BuildContext context, DateTime d) =>
    DateFormat.yMMMM(Localizations.localeOf(context).languageCode).format(d);

String bankName(BuildContext context, String code) {
  final b = bankByCode(code);
  if (b == null) return code;
  return Localizations.localeOf(context).languageCode == 'ar' ? b.nameAr : b.nameEn;
}

String cardLabel(BuildContext context, CardRow c) {
  final nick = c.nickname?.trim();
  if (nick != null && nick.isNotEmpty) return '$nick •${c.last4}';
  return '${bankName(context, c.bankCode)} •${c.last4}';
}

String categoryName(BuildContext context, CategoryRow c) =>
    Localizations.localeOf(context).languageCode == 'ar' ? c.nameAr : c.nameEn;
