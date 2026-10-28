import 'package:cg_core/cg_core.dart';
import 'package:drift/drift.dart';

import 'db/database.dart';

class _Cat {
  const _Cat(this.key, this.en, this.ar, this.icon, this.color);
  final String key, en, ar;
  final int icon, color;
}

/// Built-in categories. `icon` indexes `categoryIcons` in the UI.
const _builtin = [
  _Cat(CategoryKeys.groceries, 'Groceries', 'بقالة وسوبرماركت', 0, 0xFF2E7D32),
  _Cat(CategoryKeys.dining, 'Food & dining', 'مطاعم وأكل', 1, 0xFFEF6C00),
  _Cat(CategoryKeys.transport, 'Transport', 'مواصلات', 2, 0xFF1565C0),
  _Cat(CategoryKeys.shopping, 'Shopping', 'تسوق', 3, 0xFF8E24AA),
  _Cat(CategoryKeys.bills, 'Bills & utilities', 'فواتير', 4, 0xFF00838F),
  _Cat(CategoryKeys.subscriptions, 'Subscriptions', 'اشتراكات', 5, 0xFF5E35B1),
  _Cat(CategoryKeys.health, 'Health', 'صحة', 6, 0xFFC62828),
  _Cat(CategoryKeys.travel, 'Travel', 'سفر', 7, 0xFF0277BD),
  _Cat(CategoryKeys.entertainment, 'Entertainment', 'ترفيه', 8, 0xFFAD1457),
  _Cat(CategoryKeys.fuel, 'Fuel', 'بنزين', 9, 0xFF6D4C41),
  _Cat(CategoryKeys.education, 'Education', 'تعليم', 10, 0xFF3949AB),
  _Cat(CategoryKeys.fees, 'Fees & interest', 'رسوم وفوائد', 11, 0xFF757575),
  _Cat(CategoryKeys.other, 'Other', 'أخرى', 12, 0xFF546E7A),
];

/// Inserts built-in rows that are missing. Safe to run on every start.
Future<void> seedDefaults(AppDatabase db) async {
  await db.batch((b) {
    b.insertAll(db.categories, [
      for (final c in _builtin)
        CategoriesCompanion.insert(
          key: c.key,
          nameEn: c.en,
          nameAr: c.ar,
          icon: c.icon,
          color: c.color,
          builtin: const Value(true),
        ),
    ], mode: InsertMode.insertOrIgnore);
  });
}
