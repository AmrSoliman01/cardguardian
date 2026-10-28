import 'dart:convert';

import 'package:cg_core/cg_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../data/repos/audit_repo.dart';
import '../../data/repos/ledger_repo.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ingestion_service.dart';
import '../../ui/format.dart';
import '../../ui/widgets.dart';
import 'message_picker.dart';

/// Import a bank's CSV export: pick the file, map its columns, choose the card.
class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({super.key});

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  List<List<String>>? _rows;
  String? _fileName;
  int _dateCol = 0, _merchantCol = 1, _amountCol = 2;
  int? _currencyCol;
  CsvDateFormat _dateFormat = CsvDateFormat.dmy;
  bool _hasHeader = true;
  bool _negativeIsSpend = false;
  String _currency = 'EGP';
  String _bank = 'ABK_EG';
  final _last4 = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _last4.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['csv', 'txt']);
    final f = files.firstOrNull;
    if (f == null) return;
    final bytes = await f.xFile.readAsBytes();
    final text = utf8.decode(bytes, allowMalformed: true);
    final delimiter = text.split('\n').first.contains(';') && !text.split('\n').first.contains(',') ? ';' : ',';
    final rows = parseCsv(text, delimiter: delimiter);
    final cols = rows.isEmpty ? 0 : rows.first.length;
    setState(() {
      _rows = rows;
      _fileName = f.name;
      _dateCol = 0.clamp(0, cols - 1);
      _merchantCol = 1.clamp(0, cols - 1);
      _amountCol = (cols - 1).clamp(0, cols - 1);
    });
  }

  CsvMapping get _mapping => CsvMapping(
    dateColumn: _dateCol,
    merchantColumn: _merchantCol,
    amountColumn: _amountCol,
    currencyColumn: _currencyCol,
    dateFormat: _dateFormat,
    defaultCurrency: _currency,
    hasHeader: _hasHeader,
    negativeIsSpend: _negativeIsSpend,
  );

  Future<void> _import() async {
    final l = AppLocalizations.of(context);
    final last4 = normalizeDigits(_last4.text);
    if (!RegExp(r'^\d{4}$').hasMatch(last4)) {
      showSnack(context, l.last4Invalid);
      return;
    }
    setState(() => _busy = true);
    final result = importCsv(_rows!, _mapping, bankCode: _bank, last4: last4);
    final ledger = ref.read(ledgerProvider);
    final report = IngestReport()..failed = result.errors.length;
    for (final t in result.transactions) {
      final r = await ledger.insertParsed(t, SourceType.csv);
      r.outcome == InsertOutcome.duplicate ? report.duplicates++ : report.added++;
    }
    await ref.read(auditProvider).log(AuditEvent.importCompleted, {'source': 'csv', ...report.toMap()});
    _rows = null; // drop file contents from memory
    if (!mounted) return;
    setState(() => _busy = false);
    await showImportReport(context, report);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = _rows;
    final cols = rows == null || rows.isEmpty ? 0 : rows.map((r) => r.length).reduce((a, b) => a > b ? a : b);
    final header = rows == null || rows.isEmpty ? <String>[] : rows.first;
    String colName(int i) => _hasHeader && i < header.length && header[i].trim().isNotEmpty
        ? '${i + 1}. ${header[i].trim()}'
        : l.columnN(i + 1);
    final preview = rows == null ? null : importCsv(rows.take(6).toList(), _mapping, bankCode: _bank, last4: '0000');

    Widget colPicker(String label, int value, ValueChanged<int> onChanged) => DropdownButtonFormField<int>(
      initialValue: value.clamp(0, cols - 1),
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      items: [
        for (var i = 0; i < cols; i++)
          DropdownMenuItem(
            value: i,
            child: Text(colName(i), overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) => setState(() => onChanged(v ?? value)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.csvImportTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.csvExplainer),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.file_open_outlined),
            label: Text(_fileName ?? l.chooseFile),
            onPressed: _pick,
          ),
          if (rows != null && cols > 0) ...[
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _hasHeader,
              title: Text(l.firstRowIsHeader),
              onChanged: (v) => setState(() => _hasHeader = v),
            ),
            colPicker(l.dateColumn, _dateCol, (v) => _dateCol = v),
            const SizedBox(height: 12),
            DropdownButtonFormField<CsvDateFormat>(
              initialValue: _dateFormat,
              decoration: InputDecoration(labelText: l.dateFormat),
              items: [for (final f in CsvDateFormat.values) DropdownMenuItem(value: f, child: Text(f.label))],
              onChanged: (v) => setState(() => _dateFormat = v ?? _dateFormat),
            ),
            const SizedBox(height: 12),
            colPicker(l.merchantColumn, _merchantCol, (v) => _merchantCol = v),
            const SizedBox(height: 12),
            colPicker(l.amountColumn, _amountCol, (v) => _amountCol = v),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _negativeIsSpend,
              title: Text(l.negativeIsSpend),
              onChanged: (v) => setState(() => _negativeIsSpend = v),
            ),
            DropdownButtonFormField<int?>(
              initialValue: _currencyCol,
              decoration: InputDecoration(labelText: l.currencyColumn),
              isExpanded: true,
              items: [
                DropdownMenuItem(value: null, child: Text(l.noCurrencyColumn(_currency))),
                for (var i = 0; i < cols; i++) DropdownMenuItem(value: i, child: Text(colName(i))),
              ],
              onChanged: (v) => setState(() => _currencyCol = v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: _bank,
                    decoration: InputDecoration(labelText: l.bank),
                    isExpanded: true,
                    items: [
                      for (final b in knownBanks)
                        DropdownMenuItem(value: b.code, child: Text(bankName(context, b.code))),
                    ],
                    onChanged: (v) => setState(() => _bank = v ?? _bank),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _last4,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(labelText: l.last4),
                  ),
                ),
              ],
            ),
            TextFormField(
              initialValue: _currency,
              maxLength: 3,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(labelText: l.currency),
              onChanged: (v) => setState(() => _currency = v.toUpperCase()),
            ),
            SectionTitle(l.preview),
            if (preview != null)
              for (final t in preview.transactions)
                ListTile(
                  dense: true,
                  title: Text(t.merchant),
                  subtitle: Text('${formatDate(context, t.occurredAt)} · ${txnTypeLabel(l, t.type)}'),
                  trailing: Text(formatMoney(t.amountMinor, t.currency), textDirection: TextDirection.ltr),
                ),
            if (preview != null && preview.errors.isNotEmpty)
              Text(l.csvRowErrors(preview.errors.length), style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _import,
              child: Text(l.importRows(rows.length - (_hasHeader ? 1 : 0))),
            ),
          ],
        ],
      ),
    );
  }
}
