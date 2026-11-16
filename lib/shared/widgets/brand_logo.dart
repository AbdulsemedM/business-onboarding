import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// The FastPay mark (the card with speed lines).
///
/// Screen readers hear the app name, not the image.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).appTitle,
      image: true,
      child: ExcludeSemantics(
        child: Image.asset('assets/brand/icon.png', width: size, height: size),
      ),
    );
  }
}

/// The mark on a white rounded tile, for navy backgrounds where the navy
/// half of the mark would otherwise disappear.
class BrandBadge extends StatelessWidget {
  const BrandBadge({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.35),
            blurRadius: size * 0.4,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: BrandMark(size: size * 0.72),
    );
  }
}

/// Navy background with sky-blue speed lines, echoing the streaks in the
/// logo. Used behind the welcome and sign-in headers.
class BrandBackdrop extends StatelessWidget {
  const BrandBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.secondary,
      child: CustomPaint(painter: const _SpeedLines(), child: child),
    );
  }
}

class _SpeedLines extends CustomPainter {
  const _SpeedLines();

  // (top as a fraction of height, start as a fraction of width, length as a
  // fraction of width, opacity). Lines run off the right edge.
  static const _lines = [
    (0.10, 0.55, 0.60, 0.22),
    (0.20, 0.70, 0.40, 0.14),
    (0.31, 0.44, 0.70, 0.10),
    (0.42, 0.78, 0.30, 0.20),
    (0.56, 0.62, 0.50, 0.12),
    (0.68, 0.84, 0.25, 0.18),
    (0.80, 0.50, 0.65, 0.08),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = (size.height * 0.035).clamp(6.0, 14.0);
    for (final (top, start, length, opacity) in _lines) {
      final paint = Paint()
        ..color = AppTheme.primary.withValues(alpha: opacity);
      final left = size.width * start;
      canvas.drawRRect(
        RRect.fromLTRBR(
          left,
          size.height * top,
          left + size.width * length,
          size.height * top + thickness,
          Radius.circular(thickness / 2),
        ),
        paint,
      );
      // A short dash in front of every other line, like the logo's dots.
      if (opacity >= 0.14) {
        final dot = thickness * 1.8;
        canvas.drawRRect(
          RRect.fromLTRBR(
            left - dot - thickness,
            size.height * top,
            left - thickness,
            size.height * top + thickness,
            Radius.circular(thickness / 2),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SpeedLines oldDelegate) => false;
}
