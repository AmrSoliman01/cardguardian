import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Cell styles available in [XlsxWorkbook]. Indexes into `cellXfs`.
enum XStyle { normal, headerRequired, headerOptional, hint, date, title, wrap, bold }

class XCell {
  const XCell.text(String this.text, [this.style = XStyle.normal]) : number = null, date = null;
  const XCell.number(num this.number, [this.style = XStyle.normal]) : text = null, date = null;
  XCell.date(DateTime this.date) : text = null, number = null, style = XStyle.date;

  final String? text;
  final num? number;
  final DateTime? date;
  final XStyle style;
}

class XValidation {
  const XValidation(this.range, this.listFormula);

  /// e.g. `A3:A2000`
  final String range;

  /// e.g. `Lists!$A$2:$A$16`
  final String listFormula;
}

class XSheet {
  XSheet(this.name, {this.freezeRows = 0});
  final String name;
  final int freezeRows;
  final rows = <List<XCell?>>[];
  final colWidths = <int, double>{};
  final rowHeights = <int, double>{};
  final validations = <XValidation>[];

  void add(List<XCell?> row) => rows.add(row);
}

/// A minimal .xlsx writer: inline strings, numbers, dates, a few fixed
/// styles, column widths, frozen header rows and list validations. Enough to
/// reproduce an import template without a spreadsheet dependency.
class XlsxWorkbook {
  final sheets = <XSheet>[];

  XSheet sheet(String name, {int freezeRows = 0}) {
    final s = XSheet(name, freezeRows: freezeRows);
    sheets.add(s);
    return s;
  }

  Uint8List encode() {
    final a = Archive();
    void put(String path, String xml) {
      final bytes = utf8.encode(xml);
      a.addFile(ArchiveFile(path, bytes.length, bytes));
    }

    put('[Content_Types].xml', _contentTypes());
    put(
      '_rels/.rels',
      '$_xmlHead<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
          '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
          '</Relationships>',
    );
    put('xl/workbook.xml', _workbook());
    put('xl/_rels/workbook.xml.rels', _workbookRels());
    put('xl/styles.xml', _styles);
    for (var i = 0; i < sheets.length; i++) {
      put('xl/worksheets/sheet${i + 1}.xml', _sheet(sheets[i], selected: i == 0));
    }
    return Uint8List.fromList(ZipEncoder().encode(a));
  }

  static const _xmlHead = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n';
  static const _ns = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
  static const _rel = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships';

  String _contentTypes() {
    final b = StringBuffer(
      '$_xmlHead<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>',
    );
    for (var i = 1; i <= sheets.length; i++) {
      b.write(
        '<Override PartName="/xl/worksheets/sheet$i.xml" '
        'ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>',
      );
    }
    b.write('</Types>');
    return b.toString();
  }

  String _workbook() {
    final b = StringBuffer('$_xmlHead<workbook xmlns="$_ns" xmlns:r="$_rel"><sheets>');
    for (var i = 0; i < sheets.length; i++) {
      b.write('<sheet name="${_esc(sheets[i].name)}" sheetId="${i + 1}" r:id="rId${i + 1}"/>');
    }
    b.write('</sheets></workbook>');
    return b.toString();
  }

  String _workbookRels() {
    final b = StringBuffer(
      '$_xmlHead<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
    );
    for (var i = 0; i < sheets.length; i++) {
      b.write('<Relationship Id="rId${i + 1}" Type="$_rel/worksheet" Target="worksheets/sheet${i + 1}.xml"/>');
    }
    b.write('<Relationship Id="rId${sheets.length + 1}" Type="$_rel/styles" Target="styles.xml"/></Relationships>');
    return b.toString();
  }

  // Order matches XStyle.
  static const _styles =
      '$_xmlHead<styleSheet xmlns="$_ns">'
      '<numFmts count="1"><numFmt numFmtId="164" formatCode="yyyy-mm-dd"/></numFmts>'
      '<fonts count="5">'
      '<font><sz val="11"/><name val="Calibri"/></font>'
      '<font><b/><sz val="11"/><color rgb="FFFFFFFF"/><name val="Calibri"/></font>'
      '<font><i/><sz val="9"/><color rgb="FF64748B"/><name val="Calibri"/></font>'
      '<font><b/><sz val="16"/><name val="Calibri"/></font>'
      '<font><b/><sz val="11"/><name val="Calibri"/></font>'
      '</fonts>'
      '<fills count="4">'
      '<fill><patternFill patternType="none"/></fill>'
      '<fill><patternFill patternType="gray125"/></fill>'
      '<fill><patternFill patternType="solid"><fgColor rgb="FF1D4ED8"/><bgColor indexed="64"/></patternFill></fill>'
      '<fill><patternFill patternType="solid"><fgColor rgb="FF475569"/><bgColor indexed="64"/></patternFill></fill>'
      '</fills>'
      '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
      '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
      '<cellXfs count="8">'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
      '<xf numFmtId="0" fontId="1" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1">'
      '<alignment vertical="center" wrapText="1"/></xf>'
      '<xf numFmtId="0" fontId="1" fillId="3" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1">'
      '<alignment vertical="center" wrapText="1"/></xf>'
      '<xf numFmtId="0" fontId="2" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1">'
      '<alignment wrapText="1"/></xf>'
      '<xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>'
      '<xf numFmtId="0" fontId="3" fillId="0" borderId="0" xfId="0" applyFont="1"/>'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment wrapText="1"/></xf>'
      '<xf numFmtId="0" fontId="4" fillId="0" borderId="0" xfId="0" applyFont="1"/>'
      '</cellXfs>'
      '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>'
      '</styleSheet>';

  String _sheet(XSheet s, {required bool selected}) {
    final b = StringBuffer('$_xmlHead<worksheet xmlns="$_ns" xmlns:r="$_rel"><sheetViews>');
    b.write('<sheetView workbookViewId="0"${selected ? ' tabSelected="1"' : ''}');
    if (s.freezeRows > 0) {
      final top = 'A${s.freezeRows + 1}';
      b.write(
        '><pane ySplit="${s.freezeRows}" topLeftCell="$top" activePane="bottomLeft" state="frozen"/>'
        '<selection pane="bottomLeft" activeCell="$top" sqref="$top"/></sheetView>',
      );
    } else {
      b.write('/>');
    }
    b.write('</sheetViews><sheetFormatPr defaultRowHeight="15"/>');
    if (s.colWidths.isNotEmpty) {
      b.write('<cols>');
      for (final e in (s.colWidths.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))) {
        b.write('<col min="${e.key + 1}" max="${e.key + 1}" width="${e.value}" customWidth="1"/>');
      }
      b.write('</cols>');
    }
    b.write('<sheetData>');
    for (var r = 0; r < s.rows.length; r++) {
      final h = s.rowHeights[r];
      b.write('<row r="${r + 1}"${h == null ? '' : ' ht="$h" customHeight="1"'}>');
      final row = s.rows[r];
      for (var c = 0; c < row.length; c++) {
        final cell = row[c];
        if (cell == null) continue;
        final ref = '${columnName(c)}${r + 1}';
        final st = cell.style.index == 0 ? '' : ' s="${cell.style.index}"';
        if (cell.text != null) {
          b.write('<c r="$ref" t="inlineStr"$st><is><t xml:space="preserve">${_esc(cell.text!)}</t></is></c>');
        } else if (cell.number != null) {
          b.write('<c r="$ref"$st><v>${cell.number}</v></c>');
        } else if (cell.date != null) {
          b.write('<c r="$ref"$st><v>${excelSerial(cell.date!)}</v></c>');
        }
      }
      b.write('</row>');
    }
    b.write('</sheetData>');
    if (s.validations.isNotEmpty) {
      b.write('<dataValidations count="${s.validations.length}">');
      for (final v in s.validations) {
        b.write(
          '<dataValidation type="list" allowBlank="1" showErrorMessage="1" sqref="${v.range}">'
          '<formula1>${_esc(v.listFormula)}</formula1></dataValidation>',
        );
      }
      b.write('</dataValidations>');
    }
    b.write('</worksheet>');
    return b.toString();
  }

  /// 0 → A, 25 → Z, 26 → AA.
  static String columnName(int index) {
    var n = index + 1;
    var s = '';
    while (n > 0) {
      final m = (n - 1) % 26;
      s = String.fromCharCode(65 + m) + s;
      n = (n - 1) ~/ 26;
    }
    return s;
  }

  /// Whole days since 1899-12-30 (Excel's date serial), time dropped.
  static int excelSerial(DateTime d) =>
      DateTime.utc(d.year, d.month, d.day).difference(DateTime.utc(1899, 12, 30)).inDays;

  static final _invalidXml = RegExp('[\u0000-\u0008\u000B\u000C\u000E-\u001F]');

  static String _esc(String s) => s
      .replaceAll(_invalidXml, '')
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
