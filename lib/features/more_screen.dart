import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../l10n/app_localizations.dart';
import '../ui/widgets.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final caps = ref.watch(capabilitiesProvider).value;
    Widget tile(IconData icon, String title, String route, {String? subtitle}) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(route),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.navMore)),
      body: ListView(
        children: [
          SectionTitle(l.sectionMoney),
          tile(Icons.credit_card, l.cardsTitle, '/cards'),
          tile(Icons.calendar_month_outlined, l.installmentsTitle, '/installments'),
          tile(Icons.category_outlined, l.categoriesTitle, '/categories'),
          SectionTitle(l.sectionSources),
          tile(Icons.sms_outlined, l.sourcesTitle, '/sources', subtitle: l.sourcesSubtitle),
          tile(Icons.content_paste_go, l.pasteImportTitle, '/import/paste'),
          if (caps?.sms == true) tile(Icons.history, l.smsHistoryTitle, '/import/sms'),
          tile(Icons.table_chart_outlined, l.csvImportTitle, '/import/csv'),
          SectionTitle(l.sectionApp),
          tile(Icons.settings_outlined, l.settingsTitle, '/settings'),
          tile(Icons.backup_outlined, l.backupTitle, '/backup'),
          tile(Icons.policy_outlined, l.auditTitle, '/audit'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.lockNow),
            onTap: () => ref.read(lockProvider.notifier).lock(),
          ),
        ],
      ),
    );
  }
}
