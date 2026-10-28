import 'source_hash.dart';

/// Built-in category keys. Display names live in the app's localization.
class CategoryKeys {
  static const groceries = 'groceries';
  static const dining = 'dining';
  static const transport = 'transport';
  static const shopping = 'shopping';
  static const bills = 'bills';
  static const subscriptions = 'subscriptions';
  static const health = 'health';
  static const travel = 'travel';
  static const entertainment = 'entertainment';
  static const fuel = 'fuel';
  static const education = 'education';
  static const fees = 'fees';
  static const other = 'other';

  static const all = [
    groceries,
    dining,
    transport,
    shopping,
    bills,
    subscriptions,
    health,
    travel,
    entertainment,
    fuel,
    education,
    fees,
    other,
  ];
}

/// Maps a merchant to a category by case-insensitive substring.
class MerchantRule {
  const MerchantRule(this.pattern, this.categoryKey);
  final String pattern;
  final String categoryKey;

  bool matches(String merchant) => normalizeMerchant(merchant).contains(normalizeMerchant(pattern));
}

/// Defaults for merchants common in Egypt. User rules always win.
const List<MerchantRule> defaultMerchantRules = [
  MerchantRule('GOOGLE', CategoryKeys.subscriptions),
  MerchantRule('APPLE.COM', CategoryKeys.subscriptions),
  MerchantRule('NETFLIX', CategoryKeys.subscriptions),
  MerchantRule('SPOTIFY', CategoryKeys.subscriptions),
  MerchantRule('SHAHID', CategoryKeys.subscriptions),
  MerchantRule('ANGHAMI', CategoryKeys.subscriptions),
  MerchantRule('FAWRY', CategoryKeys.bills),
  MerchantRule('VODAFONE', CategoryKeys.bills),
  MerchantRule('ORANGE', CategoryKeys.bills),
  MerchantRule('ETISALAT', CategoryKeys.bills),
  MerchantRule('WE ', CategoryKeys.bills),
  MerchantRule('TALABAT', CategoryKeys.dining),
  MerchantRule('ELMENUS', CategoryKeys.dining),
  MerchantRule('MCDONALD', CategoryKeys.dining),
  MerchantRule('KFC', CategoryKeys.dining),
  MerchantRule('STARBUCKS', CategoryKeys.dining),
  MerchantRule('UBER', CategoryKeys.transport),
  MerchantRule('CAREEM', CategoryKeys.transport),
  MerchantRule('INDRIVE', CategoryKeys.transport),
  MerchantRule('SWVL', CategoryKeys.transport),
  MerchantRule('CARREFOUR', CategoryKeys.groceries),
  MerchantRule('SPINNEYS', CategoryKeys.groceries),
  MerchantRule('SEOUDI', CategoryKeys.groceries),
  MerchantRule('METRO MARKET', CategoryKeys.groceries),
  MerchantRule('BREADFAST', CategoryKeys.groceries),
  MerchantRule('RABBIT', CategoryKeys.groceries),
  MerchantRule('AMAZON', CategoryKeys.shopping),
  MerchantRule('NOON', CategoryKeys.shopping),
  MerchantRule('JUMIA', CategoryKeys.shopping),
  MerchantRule('PHARMACY', CategoryKeys.health),
  MerchantRule('SEIF', CategoryKeys.health),
  MerchantRule('EL EZABY', CategoryKeys.health),
  MerchantRule('VEZEETA', CategoryKeys.health),
  MerchantRule('EGYPTAIR', CategoryKeys.travel),
  MerchantRule('BOOKING.COM', CategoryKeys.travel),
  MerchantRule('AIRBNB', CategoryKeys.travel),
  MerchantRule('VOX', CategoryKeys.entertainment),
  MerchantRule('STEAM', CategoryKeys.entertainment),
  MerchantRule('PLAYSTATION', CategoryKeys.entertainment),
  MerchantRule('TOTAL', CategoryKeys.fuel),
  MerchantRule('MOBIL', CategoryKeys.fuel),
  MerchantRule('WATANIA', CategoryKeys.fuel),
  MerchantRule('UDEMY', CategoryKeys.education),
  MerchantRule('COURSERA', CategoryKeys.education),
];

/// Returns the category key for [merchant], or null if nothing matches.
/// [userRules] are checked first, then [defaults]. Longer patterns win within
/// each list so "GOOGLE*YOUTUBE" can override "GOOGLE".
String? categorize(
  String merchant, {
  List<MerchantRule> userRules = const [],
  List<MerchantRule> defaults = defaultMerchantRules,
}) {
  for (final list in [userRules, defaults]) {
    MerchantRule? best;
    for (final r in list) {
      if (r.matches(merchant) && (best == null || r.pattern.length > best.pattern.length)) {
        best = r;
      }
    }
    if (best != null) return best.categoryKey;
  }
  return null;
}
