import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cats = ref.watch(categoriesProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l.categoriesTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.addCategory,
        onPressed: () => _add(context, ref),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(l.categoriesHelp)),
          for (final c in cats)
            ListTile(
              leading: CategoryAvatar(c),
              title: Text(categoryName(context, c)),
              subtitle: c.builtin ? null : Text(l.customCategory),
            ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final ar = TextEditingController();
    final en = TextEditingController();
    var icon = 12;
    var color = categoryColors.first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: Text(l.addCategory),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ar,
                  decoration: InputDecoration(labelText: l.nameArabic),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: en,
                  decoration: InputDecoration(labelText: l.nameEnglish),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  children: [
                    for (var i = 0; i < categoryIcons.length; i++)
                      IconButton(
                        isSelected: icon == i,
                        icon: Icon(categoryIcons[i]),
                        onPressed: () => set(() => icon = i),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final col in categoryColors)
                      GestureDetector(
                        onTap: () => set(() => color = col),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(col),
                          child: color == col ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final nameAr = ar.text.trim().isEmpty ? en.text.trim() : ar.text.trim();
    final nameEn = en.text.trim().isEmpty ? nameAr : en.text.trim();
    if (nameAr.isEmpty) return;
    await ref.read(ledgerProvider).addCategory(nameEn, nameAr, icon, color);
  }
}
