import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:flutter/material.dart';

const _ui = 'Plus Jakarta Sans';

const _paper = Color(0xFFF9F6F0);
const _ink = Color(0xFF2A2118);
const _clay = Color(0xFFC85A32);
const _clayOnDark = Color(0xFFE39274);
const _sand = Color(0xFFD99B61);
const _sage = Color(0xFF5E7C69);
const _sageOnDark = Color(0xFF8FAE98);
const _white = Color(0xFFFFFFFF);
const _night = Color(0xFF1A1410);
const _nightSurface = Color(0xFF2A221C);
const _muted = Color(0xFF6F675E);
const _mutedOnDark = Color(0xFFC4B8AA);
const _line = Color(0xFFE7E0D6);
const _lineOnDark = Color(0xFF3E342C);
const _danger = Color(0xFF9F1239);
const _dangerOnDark = Color(0xFFFDA4AF);

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isLight ? _clay : _clayOnDark,
      onPrimary: _white,
      secondary: _sand,
      onSecondary: isLight ? _ink : _night,
      tertiary: isLight ? _sage : _sageOnDark,
      onTertiary: isLight ? _white : _night,
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
        elevation: 1,
        shadowColor: _ink.withValues(alpha: 0.12),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _clay,
          foregroundColor: _white,
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _clay,
          minimumSize: const Size(48, 48),
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        border: _fieldBorder(scheme.outline),
        enabledBorder: _fieldBorder(scheme.outline),
        focusedBorder: _fieldBorder(_clay, width: 2),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: _clay),
      iconTheme: IconThemeData(color: scheme.onSurface),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.field),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final base = ThemeData(brightness: scheme.brightness).textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      fontFamily: _ui,
    );
    TextStyle? title(TextStyle? style, {FontWeight weight = FontWeight.w600}) {
      return style?.copyWith(fontWeight: weight, color: scheme.onSurface);
    }

    return base.copyWith(
      displayLarge: title(base.displayLarge, weight: FontWeight.w700),
      displayMedium: title(base.displayMedium, weight: FontWeight.w700),
      displaySmall: title(base.displaySmall, weight: FontWeight.w700),
      headlineLarge: title(base.headlineLarge, weight: FontWeight.w700),
      headlineMedium: title(base.headlineMedium, weight: FontWeight.w700),
      headlineSmall: title(base.headlineSmall, weight: FontWeight.w700),
      titleLarge: title(base.titleLarge, weight: FontWeight.w700),
    );
  }
}
