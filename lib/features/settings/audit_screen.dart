import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';

final _auditProvider = StreamProvider<List<AuditRow>>((ref) => ref.watch(auditProvider).watchRecent());

/// Local log of security events (imports, exports, unlock failures...).
class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final rows = ref.watch(_auditProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l.auditTitle)),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(l.auditHelp)),
          for (final r in rows)
            ListTile(
              dense: true,
              title: Text(r.event),
              subtitle: r.details == null ? null : Text(r.details!, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Text(formatDateTime(context, r.at), style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}
