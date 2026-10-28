/// Splits pasted text that may hold many messages into single messages.
///
/// Blank lines separate messages. Inside a block, a known message start
/// (e.g. "Your Credit Card#") also begins a new message, so a copy of a whole
/// conversation without blank lines still splits correctly.
List<String> splitMessages(String text, {List<RegExp> starts = const []}) {
  final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final blocks = normalized.split(RegExp(r'\n\s*\n'));
  final out = <String>[];
  for (final block in blocks) {
    final b = block.trim();
    if (b.isEmpty) continue;
    final cuts = <int>{0};
    for (final s in starts) {
      for (final m in s.allMatches(b)) {
        cuts.add(m.start);
      }
    }
    final sorted = cuts.toList()..sort();
    for (var i = 0; i < sorted.length; i++) {
      final end = i + 1 < sorted.length ? sorted[i + 1] : b.length;
      final piece = b.substring(sorted[i], end).trim();
      if (piece.isNotEmpty) out.add(piece.replaceAll(RegExp(r'\s*\n\s*'), ' '));
    }
  }
  return out;
}
