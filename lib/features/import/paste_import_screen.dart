import 'package:cg_core/cg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/format.dart';
import 'message_picker.dart';

/// Paste one or many bank messages, preview what was understood, tick the
/// ones to import. Also the history-backfill path on iPhone.
class PasteImportScreen extends ConsumerStatefulWidget {
  const PasteImportScreen({super.key});

  @override
  ConsumerState<PasteImportScreen> createState() => _PasteImportScreenState();
}

class _PasteImportScreenState extends ConsumerState<PasteImportScreen> {
  final _text = TextEditingController();
  String? _bankCode;
  List<PickItem>? _items;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) setState(() => _text.text = data!.text!);
  }

  Future<void> _preview() async {
    final registry = ParserRegistry.defaults();
    final now = DateTime.now();
    final parts = splitMessages(_text.text, starts: registry.messageStarts);
    final msgs = [for (final p in parts) RawMessage(sourceType: SourceType.paste, body: p, receivedAt: now)];
    final items = await buildPickItems(ref, msgs, bankCode: _bankCode);
    setState(() => _items = items);
  }

  Future<void> _import(List<RawMessage> selected) async {
    final r = await ref.read(ingestionProvider).ingest(selected, bankCode: _bankCode);
    // Clear the pasted text from memory once imported.
    _text.clear();
    if (!mounted) return;
    await showImportReport(context, r);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.pasteImportTitle),
        leading: _items == null ? null : BackButton(onPressed: () => setState(() => _items = null)),
      ),
      body: _items != null
          ? MessagePicker(items: _items!, onImport: _import)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l.pasteExplainer),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _bankCode,
                  decoration: InputDecoration(labelText: l.bank),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l.detectAutomatically)),
                    for (final b in knownBanks.where((b) => b.code != 'OTHER'))
                      DropdownMenuItem(value: b.code, child: Text(bankName(context, b.code))),
                  ],
                  onChanged: (v) => setState(() => _bankCode = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _text,
                  minLines: 8,
                  maxLines: 16,
                  decoration: InputDecoration(
                    hintText: l.pasteHint,
                    alignLabelWithHint: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.content_paste),
                      tooltip: l.pasteFromClipboard,
                      onPressed: _pasteFromClipboard,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.preview_outlined),
                  label: Text(l.preview),
                  onPressed: _text.text.trim().isEmpty ? null : _preview,
                ),
              ],
            ),
    );
  }
}
