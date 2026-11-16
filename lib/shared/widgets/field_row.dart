import 'package:flutter/material.dart';

/// Short fields side by side (first/last name, city/state, open/close).
///
/// Stacks them instead when each would get too little room, e.g. on a
/// narrow phone or with a large text size, so labels never get cut off.
class FieldRow extends StatelessWidget {
  const FieldRow({
    super.key,
    required this.children,
    this.flex,
    this.minFieldWidth = 140,
  });

  final List<Widget> children;

  /// Relative widths, one per child. Equal widths by default.
  final List<int>? flex;

  /// Narrowest a field may get at normal text size before the row stacks.
  final double minFieldWidth;

  static const _gap = 12.0;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final perField =
            (constraints.maxWidth - _gap * (children.length - 1)) /
            children.length;
        if (perField < minFieldWidth * textScale) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0) const SizedBox(height: 16),
                child,
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, child) in children.indexed) ...[
              if (i > 0) const SizedBox(width: _gap),
              Expanded(flex: flex?[i] ?? 1, child: child),
            ],
          ],
        );
      },
    );
  }
}
