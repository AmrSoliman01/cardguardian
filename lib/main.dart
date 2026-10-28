import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

void main() => runApp(const _Placeholder());

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (c) => Scaffold(body: Center(child: Text(AppLocalizations.of(c).appTitle))),
    ),
  );
}
