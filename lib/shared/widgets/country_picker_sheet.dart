import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../core/utils/phone_validation.dart';
import '../../l10n/app_localizations.dart';

/// Bottom sheet listing countries by flag, ISO code and dial code.
/// Returns the chosen [IsoCode], or null if dismissed.
Future<IsoCode?> showCountryPickerSheet(BuildContext context) {
  return showModalBottomSheet<IsoCode>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _CountryPicker(),
  );
}

class _CountryPicker extends StatefulWidget {
  const _CountryPicker();

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<_CountryPicker> {
  // US first, the rest alphabetical by ISO code.
  static final List<IsoCode> _all = [
    IsoCode.US,
    ...IsoCode.values.where((c) => c != IsoCode.US).toList()
      ..sort((a, b) => a.name.compareTo(b.name)),
  ];

  String _query = '';

  List<IsoCode> get _filtered {
    final q = _query.trim().toUpperCase().replaceAll('+', '');
    if (q.isEmpty) return _all;
    return _all
        .where((c) => c.name.startsWith(q) || dialCodeFor(c).startsWith(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final countries = _filtered;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.countrySearchLabel,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final iso = countries[index];
                return ListTile(
                  leading: ExcludeSemantics(child: Text(flagEmoji(iso))),
                  title: Text(iso.name),
                  trailing: Text('+${dialCodeFor(iso)}'),
                  onTap: () => Navigator.of(context).pop(iso),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
