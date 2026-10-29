import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/providers.dart';
import '../../data/db/database.dart';
import '../../data/repos/audit_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../services/backup_service.dart';
import '../../services/excel_export_service.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';

/// Encrypted backup/restore and CSV export. Files are only handed to the
/// system share sheet; the user decides where they go.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  String _stamp() {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${n.year}${two(n.month)}${two(n.day)}-${two(n.hour)}${two(n.minute)}';
  }

  /// Writes [bytes] to a temp file, opens the share sheet, then deletes it.
  Future<void> _shareFile(String name, Uint8List bytes, String mime) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(bytes, flush: true);
    try {
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: mime)]));
    } finally {
      if (await file.exists()) await file.delete();
    }
  }

  Future<String?> _askPassphrase({required bool confirmIt}) async {
    final l = AppLocalizations.of(context);
    final a = TextEditingController();
    final b = TextEditingController();
    final form = GlobalKey<FormState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(confirmIt ? l.choosePassphrase : l.enterPassphrase),
        content: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (confirmIt) Text(l.passphraseWarning, style: Theme.of(c).textTheme.bodySmall),
              TextFormField(
                controller: a,
                obscureText: true,
                decoration: InputDecoration(labelText: l.passphrase),
                validator: (v) => confirmIt && (v ?? '').length < 8 ? l.passphraseTooShort : null,
              ),
              if (confirmIt)
                TextFormField(
                  controller: b,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l.confirmPassphrase),
                  validator: (v) => v != a.text ? l.passphraseMismatch : null,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) Navigator.pop(c, true);
            },
            child: Text(l.ok),
          ),
        ],
      ),
    );
    return ok == true ? a.text : null;
  }

  Future<void> _run(Future<void> Function() job) async {
    setState(() => _busy = true);
    try {
      await job();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backup() async {
    final pass = await _askPassphrase(confirmIt: true);
    if (pass == null) return;
    await _run(() async {
      final bytes = await ref.read(backupServiceProvider).createBackup(pass);
      await ref.read(auditProvider).log(AuditEvent.backupCreated);
      await _shareFile('cardguardian-${_stamp()}.cgbackup', bytes, 'application/octet-stream');
    });
  }

  Future<void> _restore() async {
    final l = AppLocalizations.of(context);
    final files = await FilePicker.pickFiles();
    final f = files.firstOrNull;
    if (f == null) return;
    final bytes = await f.xFile.readAsBytes();
    final pass = await _askPassphrase(confirmIt: false);
    if (pass == null || !mounted) return;
    await _run(() async {
      final svc = ref.read(backupServiceProvider);
      try {
        final data = await svc.readBackup(bytes, pass);
        if (!mounted) return;
        if (!await confirm(context, title: l.restoreQ, message: l.restoreWarning, action: l.restore)) return;
        await svc.restore(data);
        await ref.read(auditProvider).log(AuditEvent.backupRestored);
        if (mounted) showSnack(context, l.restoreDone);
      } on WrongPassphraseError {
        if (mounted) showSnack(context, l.wrongPassphrase);
      } on BackupFormatError {
        if (mounted) showSnack(context, l.notABackup);
      }
    });
  }

  Future<void> _exportCsv() async {
    await _run(() async {
      final csv = await ref.read(exportServiceProvider).transactionsCsv();
      await ref.read(auditProvider).log(AuditEvent.exportCreated, {'format': 'csv'});
      // UTF-8 BOM so Excel shows Arabic correctly.
      await _shareFile(
        'cardguardian-${_stamp()}.csv',
        Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]),
        'text/csv',
      );
    });
  }

  /// Asks for "Paid by" and the card nicknames the import template needs,
  /// then exports the workbook.
  Future<void> _exportExcel() async {
    final l = AppLocalizations.of(context);
    final settings = ref.read(settingsRepoProvider);
    final ledger = ref.read(ledgerProvider);
    final cards = await ledger.cards();
    final paidBy = TextEditingController(text: await settings.getRaw('exportPaidBy') ?? '');
    final nicks = {for (final c in cards) c.id: TextEditingController(text: c.nickname ?? '')};
    if (!mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.exportExcel),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.exportExcelExplainer, style: Theme.of(c).textTheme.bodySmall),
              const SizedBox(height: 12),
              TextField(
                controller: paidBy,
                decoration: InputDecoration(labelText: l.paidBy, helperText: l.paidByHelp),
              ),
              for (final card in cards) ...[
                const SizedBox(height: 12),
                ListenableBuilder(
                  listenable: paidBy,
                  builder: (c, _) => TextField(
                    controller: nicks[card.id],
                    decoration: InputDecoration(
                      labelText: l.cardNicknameFor('${bankName(c, card.bankCode)} •${card.last4}'),
                      hintText: ExcelExportService.cardNickname(
                        card.copyWith(nickname: const Value(null)),
                        cards,
                        paidBy.text,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l.export)),
        ],
      ),
    );
    if (ok != true) return;
    await _run(() async {
      await settings.setRaw('exportPaidBy', paidBy.text.trim());
      for (final card in cards) {
        final n = nicks[card.id]!.text.trim();
        if (n != (card.nickname ?? '')) {
          await ledger.updateCard(CardsCompanion(id: Value(card.id), nickname: Value(n.isEmpty ? null : n)));
        }
      }
      final r = await ref.read(excelExportServiceProvider).build(paidBy: paidBy.text.trim());
      await ref.read(auditProvider).log(AuditEvent.exportCreated, {'format': 'xlsx'});
      await _shareFile(
        'cardguardian-${_stamp()}.xlsx',
        r.bytes,
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      if (mounted) showSnack(context, l.exportExcelDone(r.purchases, r.payments, r.statements));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.backupTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          children: [
            if (_busy) const LinearProgressIndicator(),
            Padding(padding: const EdgeInsets.all(16), child: Text(l.backupExplainer)),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: Text(l.createBackup),
              subtitle: Text(l.createBackupHelp),
              onTap: _backup,
            ),
            ListTile(
              leading: const Icon(Icons.settings_backup_restore),
              title: Text(l.restoreBackup),
              subtitle: Text(l.restoreBackupHelp),
              onTap: _restore,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.table_view_outlined),
              title: Text(l.exportCsv),
              subtitle: Text(l.exportCsvHelp),
              onTap: _exportCsv,
            ),
            ListTile(
              leading: const Icon(Icons.grid_on_outlined),
              title: Text(l.exportExcel),
              subtitle: Text(l.exportExcelHelp),
              onTap: _exportExcel,
            ),
          ],
        ),
      ),
    );
  }
}
