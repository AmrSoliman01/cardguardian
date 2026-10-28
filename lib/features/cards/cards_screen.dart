import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cards = ref.watch(cardsProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l.cardsTitle)),
      body: cards.isEmpty
          ? EmptyState(icon: Icons.credit_card_off_outlined, title: l.noCardsTitle, message: l.cardsAutoCreated)
          : ListView(
              children: [
                for (final c in cards)
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(cardLabel(context, c)),
                    subtitle: Text(
                      c.lastAvailableMinor == null
                          ? bankName(context, c.bankCode)
                          : '${l.availableLimit}: ${formatMoney(c.lastAvailableMinor!, c.lastAvailableCurrency ?? c.currency)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/cards/${c.id}'),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l.cardsAutoCreated, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
    );
  }
}
