import 'package:flutter/material.dart';

/// FastPay brand theme, using the two logo colors exactly: navy and sky.
///
/// Navy is the primary color (buttons, progress, selections, text on
/// white). Sky is the accent: brand details like the speed lines, and the
/// light tint of a text field while typing.
class AppTheme {
  const AppTheme._();

  static const navy = Color(0xFF131D70);
  static const sky = Color(0xFF01A8F9);
  static const white = Color(0xFFFFFFFF);

  // Tints and neutrals derived from the brand colors.
  static const _navyTint = Color(0xFFE7E8F1);
  static const _skyTint = Color(0xFFE5F6FE);
  static const _ink = Color(0xFF161C3F);
  static const _inkMuted = Color(0xFF585E7E);
  static const _outline = Color(0xFFC8CCE0);
  static const _outlineSoft = Color(0xFFE6E8F2);
  static const _fieldFill = Color(0xFFF5F7FB);
  static const _error = Color(0xFFD23B3B);

  static const radius = 12.0;
  static const cardRadius = 16.0;

  static ThemeData light() {
    const colors = ColorScheme.light(
      primary: navy,
      onPrimary: white,
      primaryContainer: _navyTint,
      onPrimaryContainer: navy,
      // Code uses `secondary` for navy text on white; keep it navy.
      secondary: navy,
      onSecondary: white,
      secondaryContainer: _navyTint,
      onSecondaryContainer: navy,
      tertiary: sky,
      onTertiary: navy,
      error: _error,
      onError: white,
      errorContainer: Color(0xFFFDE8E8),
      onErrorContainer: Color(0xFF8A1F1F),
      surface: white,
      onSurface: _ink,
      surfaceContainerLowest: white,
      surfaceContainerLow: Color(0xFFF9FAFD),
      surfaceContainer: _fieldFill,
      surfaceContainerHigh: Color(0xFFEFF2F8),
      surfaceContainerHighest: Color(0xFFE9EDF5),
      onSurfaceVariant: _inkMuted,
      outline: _outline,
      outlineVariant: _outlineSoft,
      inverseSurface: navy,
      onInverseSurface: white,
      inversePrimary: _skyTint,
    );
    return _build(colors);
  }

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: navy,
      tertiary: sky,
      brightness: Brightness.dark,
    ),
  );

  static ThemeData _build(ColorScheme colors) {
    final isLight = colors.brightness == Brightness.light;
    final headingColor = isLight ? navy : colors.onSurface;
    const minButtonSize = Size(64, 52);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    // Text fields have no border in any state: the fill shows focus (sky
    // tint) and errors (red tint), and the error text sits underneath.
    final noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none,
    );
    final fieldFill = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return colors.surfaceContainerLow;
      }
      if (states.contains(WidgetState.error)) return colors.errorContainer;
      // Sky tint: a navy tint would hardly show against the grey fill.
      if (states.contains(WidgetState.focused)) {
        return isLight ? _skyTint : colors.primaryContainer;
      }
      return isLight ? colors.surfaceContainerHigh : colors.surfaceContainer;
    });

    final base = ThemeData(
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
    );
    final text = base.textTheme;

    return base.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: headingColor,
          letterSpacing: -0.5,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: headingColor,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: headingColor,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: headingColor,
        ),
        titleSmall: text.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: headingColor,
        ),
        bodyLarge: text.bodyLarge?.copyWith(height: 1.4),
        bodyMedium: text.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
          height: 1.4,
        ),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: headingColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: headingColor,
          letterSpacing: -0.3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        errorMaxLines: 3,
        helperMaxLines: 3,
        border: noBorder,
        enabledBorder: noBorder,
        focusedBorder: noBorder,
        errorBorder: noBorder,
        focusedErrorBorder: noBorder,
        disabledBorder: noBorder,
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        floatingLabelStyle: TextStyle(
          color: colors.secondary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: colors.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIconColor: colors.onSurfaceVariant,
        suffixIconColor: colors.onSurfaceVariant,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: minButtonSize,
          shape: buttonShape,
          textStyle: buttonText,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: minButtonSize,
          shape: buttonShape,
          textStyle: buttonText,
          foregroundColor: colors.secondary,
          side: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.secondary,
          textStyle: buttonText,
          shape: buttonShape,
          minimumSize: const Size(48, 48),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colors.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.primaryContainer,
        checkmarkColor: colors.secondary,
        side: BorderSide(color: colors.outline),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        showCheckmark: true,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colors.secondary,
        titleTextStyle: text.bodyLarge?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? white : colors.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.primary
              : colors.surfaceContainerHighest,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : colors.outline,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.secondary
              : colors.outline,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.primaryContainer,
        linearMinHeight: 6,
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.inverseSurface,
        contentTextStyle: TextStyle(color: colors.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: headingColor,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(colors.surface),
          shape: WidgetStatePropertyAll(buttonShape),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colors.surface,
        headerBackgroundColor: colors.primary,
        headerForegroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
