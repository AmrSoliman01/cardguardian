import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Numeric keypad with dot indicators. PINs are 4 to 8 digits.
class PinPad extends StatefulWidget {
  const PinPad({
    super.key,
    required this.onSubmit,
    this.minLength = 4,
    this.maxLength = 8,
    this.leadingAction,
    this.enabled = true,
  });

  final ValueChanged<String> onSubmit;
  final int minLength;
  final int maxLength;

  /// Shown in the bottom-left cell, e.g. a fingerprint button.
  final Widget? leadingAction;
  final bool enabled;

  @override
  State<PinPad> createState() => PinPadState();
}

class PinPadState extends State<PinPad> {
  String _pin = '';

  void clear() => setState(() => _pin = '');

  void _tap(String d) {
    if (!widget.enabled || _pin.length >= widget.maxLength) return;
    HapticFeedback.selectionClick();
    setState(() => _pin += d);
  }

  void _back() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _submit() {
    if (!widget.enabled || _pin.length < widget.minLength) return;
    final p = _pin;
    widget.onSubmit(p);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget key(String d) => _Key(
      onTap: () => _tap(d),
      child: Text(d, style: Theme.of(context).textTheme.headlineSmall),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < (_pin.length < widget.minLength ? widget.minLength : _pin.length); i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _pin.length ? scheme.primary : Colors.transparent,
                      border: Border.all(color: scheme.primary, width: 2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [for (final d in row) key(d)]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Key(onTap: null, child: widget.leadingAction ?? const SizedBox()),
              key('0'),
              _Key(onTap: _pin.isEmpty ? null : _back, onLongPress: clear, child: const Icon(Icons.backspace_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: widget.enabled && _pin.length >= widget.minLength ? _submit : null,
            icon: const Icon(Icons.check),
            label: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.onTap, required this.child, this.onLongPress});
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(6),
    child: SizedBox(
      width: 72,
      height: 64,
      child: onTap == null && onLongPress == null
          ? Center(child: child)
          : InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: onTap,
              onLongPress: onLongPress,
              child: Center(child: child),
            ),
    ),
  );
}
