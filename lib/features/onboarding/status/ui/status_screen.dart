import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/coming_soon.dart';

// TODO(build-step-8): status and re-upload of rejected items.
class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).statusTitle)),
      body: const ComingSoon(),
    );
  }
}
