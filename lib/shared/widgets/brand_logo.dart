import 'dart:ui';

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
            color: AppTheme.sky.withValues(alpha: 0.35),
            blurRadius: size * 0.4,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: BrandMark(size: size * 0.72),
    );
  }
}

/// A see-through, frosted panel for content on [BrandBackdrop]: the speed
/// lines behind are blurred and lightly tinted, so it blends into the navy.
class FrostedPanel extends StatelessWidget {
  const FrostedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  static const radius = 24.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          color: AppTheme.white.withValues(alpha: 0.07),
          child: child,
        ),
      ),
    );
  }
}

/// Background with sky-blue speed lines, echoing the streaks in the logo.
/// Navy on the start screen; white with the lines along the right edge on
/// the sign-in screens.
class BrandBackdrop extends StatelessWidget {
  const BrandBackdrop({
    super.key,
    required this.child,
    this.color = AppTheme.navy,
    this.rightOnly = false,
  });

  final Widget child;
  final Color color;

  /// Keeps the lines in the right part of the screen, clear of content.
  final bool rightOnly;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: CustomPaint(
        painter: _SpeedLines(rightOnly: rightOnly),
        child: child,
      ),
    );
  }
}

class _SpeedLines extends CustomPainter {
  const _SpeedLines({required this.rightOnly});

  final bool rightOnly;

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
      final paint = Paint()..color = AppTheme.sky.withValues(alpha: opacity);
      // Right-only: squeeze the starts towards the right edge.
      final left =
          size.width * (rightOnly ? 0.86 + (start - 0.44) * 0.2 : start);
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
  bool shouldRepaint(_SpeedLines oldDelegate) =>
      oldDelegate.rightOnly != rightOnly;
}
