import 'package:flutter/material.dart';

const _display = 'Fraunces';
const _ui = 'Source Sans 3';

const _paper = Color(0xFFF7F5F0);
const _ink = Color(0xFF293241);
const _green = Color(0xFF52796F);
const _greenOnDark = Color(0xFF8FB8AA);
const _teal = Color(0xFF84A9AC);
const _peach = Color(0xFFE9A87C);
const _white = Color(0xFFFFFFFF);
const _night = Color(0xFF161C22);
const _nightSurface = Color(0xFF222A32);
const _muted = Color(0xFF52606A);
const _mutedOnDark = Color(0xFFA8B3B0);
const _line = Color(0xFFE3DFD6);
const _lineOnDark = Color(0xFF3A4450);
const _danger = Color(0xFF9F1239);
const _dangerOnDark = Color(0xFFFDA4AF);

/// Paleta clara y oscura. El brillo lo elige el sistema en `CatbreedsApp`.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isLight ? _green : _greenOnDark,
      onPrimary: isLight ? _white : _night,
      secondary: _teal,
      onSecondary: isLight ? _ink : _night,
      tertiary: _peach,
      onTertiary: isLight ? _ink : _night,
      error: isLight ? _danger : _dangerOnDark,
      onError: isLight ? _white : _night,
      surface: isLight ? _paper : _night,
      onSurface: isLight ? _ink : _paper,
      onSurfaceVariant: isLight ? _muted : _mutedOnDark,
      outline: isLight ? _line : _lineOnDark,
      outlineVariant: isLight ? _line : _lineOnDark,
      surfaceContainerLowest: isLight ? _white : _nightSurface,
      surfaceContainerLow: isLight ? _white : _nightSurface,
      surfaceContainerHighest: isLight ? _white : _nightSurface,
    );

    final text = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: _ui,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, space: 1, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: _white,
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: _fieldBorder(scheme.outline),
        enabledBorder: _fieldBorder(scheme.outline),
        focusedBorder: _fieldBorder(scheme.primary, width: 2),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      iconTheme: IconThemeData(color: scheme.onSurface),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final base = ThemeData(brightness: scheme.brightness).textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      fontFamily: _ui,
    );
    TextStyle? display(TextStyle? style) {
      return style?.copyWith(
        fontFamily: _display,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      );
    }

    return base.copyWith(
      displayLarge: display(base.displayLarge),
      displayMedium: display(base.displayMedium),
      displaySmall: display(base.displaySmall),
      headlineLarge: display(base.headlineLarge),
      headlineMedium: display(base.headlineMedium),
      headlineSmall: display(base.headlineSmall),
      titleLarge: display(base.titleLarge),
    );
  }
}
