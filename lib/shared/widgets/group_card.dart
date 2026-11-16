import 'package:flutter/material.dart';

/// Soft bordered panel that groups related fields, e.g. one partner or one
/// transaction processor, so repeated entries are easy to tell apart.
class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: child,
    );
  }
}
