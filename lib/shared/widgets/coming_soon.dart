import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Temporary body for screens that are not built yet.
class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          AppLocalizations.of(context).comingSoon,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
