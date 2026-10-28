import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/widgets.dart';

/// Step-by-step setup of the iOS Shortcuts automation that forwards bank
/// SMS to CardGuardian (iOS does not let apps read SMS directly).
class IosShortcutGuide extends StatelessWidget {
  const IosShortcutGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final steps = [l.iosStep1, l.iosStep2, l.iosStep3, l.iosStep4, l.iosStep5, l.iosStep6, l.iosStep7];
    return Scaffold(
      appBar: AppBar(title: Text(l.shortcutSetupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.iosGuideIntro, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          for (final (i, s) in steps.indexed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
              title: Text(s),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.copy),
            label: Text(l.copyFilterText('Credit Card#')),
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'Credit Card#'));
              showSnack(context, l.copied);
            },
          ),
          SectionTitle(l.iosShareSheetTitle),
          Text(l.iosShareSheetBody),
          SectionTitle(l.iosHistoryTitle),
          Text(l.iosHistoryBody),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.iosPrivacyNote)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
