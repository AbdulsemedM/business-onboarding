import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// The FastPay wordmark with its card icon, for the top of a screen.
///
/// Decorative: screen readers hear the app name, not the image.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height = 44});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).appTitle,
      image: true,
      child: ExcludeSemantics(
        child: Image.asset(
          'assets/brand/logo.png',
          height: height,
          fit: BoxFit.contain,
          alignment: AlignmentDirectional.centerStart,
        ),
      ),
    );
  }
}

/// Just the app icon, for places too narrow for the full logo.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Image.asset('assets/brand/icon.png', width: size, height: size),
    );
  }
}
