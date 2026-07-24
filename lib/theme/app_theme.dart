import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ladle_colors.dart';

/// Light + dark `ThemeData`, built from [LadleColors].
/// Headings use Playfair Display, body text uses DM Sans — per
/// docs/figma-export/style/fonts.css.
class AppTheme {
  AppTheme._();

  static ThemeData light = _build(LadleColors.light, Brightness.light);
  static ThemeData dark = _build(LadleColors.dark, Brightness.dark);

  static ThemeData _build(LadleColors colors, Brightness brightness) {
    final textTheme = _textTheme(colors);

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.primaryFg,
        secondary: colors.bannerAccent,
        onSecondary: colors.guidedFg,
        error: colors.heartFill,
        onError: colors.primaryFg,
        surface: colors.card,
        onSurface: colors.body,
      ),
      textTheme: textTheme,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      extensions: [colors],
    );
  }

  static TextTheme _textTheme(LadleColors colors) {
    final heading = GoogleFonts.playfairDisplay(color: colors.heading);
    final body = GoogleFonts.dmSans(color: colors.body);

    return TextTheme(
      displayLarge: heading.copyWith(fontWeight: FontWeight.w800),
      displayMedium: heading.copyWith(fontWeight: FontWeight.w800),
      displaySmall: heading.copyWith(fontWeight: FontWeight.w800),
      headlineLarge: heading.copyWith(fontWeight: FontWeight.w800),
      headlineMedium: heading.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: heading.copyWith(fontWeight: FontWeight.w700),
      titleLarge: heading.copyWith(fontWeight: FontWeight.w700),
      titleMedium: body.copyWith(fontWeight: FontWeight.w600),
      titleSmall: body.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: body.copyWith(fontWeight: FontWeight.w400),
      bodyMedium: body.copyWith(fontWeight: FontWeight.w400),
      bodySmall: body.copyWith(color: colors.muted, fontWeight: FontWeight.w400),
      labelLarge: body.copyWith(fontWeight: FontWeight.w600),
      labelMedium: body.copyWith(fontWeight: FontWeight.w500),
      labelSmall: body.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
