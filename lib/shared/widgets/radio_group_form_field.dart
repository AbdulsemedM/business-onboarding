import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RadioOption<T> {
  const RadioOption({required this.value, required this.title, this.subtitle});

  final T value;
  final String title;
  final String? subtitle;
}

/// Radio list where each option is a bordered, full-width tile with an
/// optional explanation. The selected tile is outlined in the brand color.
/// Tapping anywhere on the tile selects it, and screen readers read the
/// title and explanation together with the radio state.
class RadioGroupFormField<T> extends StatelessWidget {
  const RadioGroupFormField({
    super.key,
    required this.name,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.validator,
  });

  final String name;
  final List<RadioOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      builder: (field) => InputDecorator(
        decoration: InputDecoration(
          errorText: field.errorText,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        child: RadioGroup<T>(
          groupValue: field.value,
          onChanged: field.didChange,
          child: Column(
            children: [
              for (final option in options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  // The tile paints its border and fill on the nearest
                  // Material. Give it its own, or a parent with a
                  // background (e.g. GroupCard) hides them.
                  child: Material(
                    type: MaterialType.transparency,
                    child: _OptionTile(
                      option: option,
                      selected: field.value == option.value,
                      colors: colors,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile<T> extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.colors,
  });

  final RadioOption<T> option;
  final bool selected;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: option.value,
      selected: selected,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
          width: selected ? 1.5 : 1,
        ),
      ),
      tileColor: colors.surface,
      selectedTileColor: colors.primaryContainer.withValues(alpha: 0.4),
      title: Text(
        option.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? colors.secondary : colors.onSurface,
        ),
      ),
      subtitle: option.subtitle == null ? null : Text(option.subtitle!),
    );
  }
}
