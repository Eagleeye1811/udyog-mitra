import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/color_schemes.dart';
import 'package:udyogmitra/src/config/themes/extensions/app_card_theme.dart';
import 'package:udyogmitra/src/config/themes/extensions/app_typography.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    useMaterial3: true,
    primaryColor: ColorSchemes.lightColorScheme.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    extensions: <ThemeExtension<dynamic>>[
      appTypographyLight,
      appCardThemeLight,
    ],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    useMaterial3: true,
    primaryColor: ColorSchemes.darkColorScheme.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    extensions: <ThemeExtension<dynamic>>[appTypographyDark, appCardThemeDark],
  );
}

extension ThemeContext on BuildContext {
  AppTypography get textStyles => Theme.of(this).extension<AppTypography>()!;
  AppCardTheme get cardStyles => Theme.of(this).extension<AppCardTheme>()!;
}
