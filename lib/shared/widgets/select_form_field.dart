import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SelectOption<T> {
  const SelectOption({required this.value, required this.title, this.subtitle});

  final T value;
  final String title;
  final String? subtitle;
}

/// A compact dropdown for picking one of a few options.
///
/// In the open menu each option shows its title and optional explanation.
/// The closed field shows only the title; the selected option's explanation
/// appears under the field as helper text.
class SelectFormField<T> extends StatefulWidget {
  const SelectFormField({
    super.key,
    required this.name,
    required this.label,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.validator,
  });

  final String name;
  final String label;
  final List<SelectOption<T>> options;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  @override
  State<SelectFormField<T>> createState() => _SelectFormFieldState<T>();
}

class _SelectFormFieldState<T> extends State<SelectFormField<T>> {
  late T? _value = widget.initialValue;

  String? get _selectedSubtitle {
    for (final option in widget.options) {
      if (option.value == _value) return option.subtitle;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormBuilderDropdown<T>(
      name: widget.name,
      initialValue: widget.initialValue,
      isExpanded: true,
      // Let menu items grow to fit a two-line title + explanation.
      itemHeight: null,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: _selectedSubtitle,
        helperMaxLines: 4,
      ),
      selectedItemBuilder: (context) => [
        for (final option in widget.options)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(option.title, overflow: TextOverflow.ellipsis),
          ),
      ],
      items: [
        for (final option in widget.options)
          DropdownMenuItem<T>(
            value: option.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option.title),
                  if (option.subtitle case final subtitle?)
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
      validator: widget.validator,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChanged?.call(value);
      },
    );
  }
}
