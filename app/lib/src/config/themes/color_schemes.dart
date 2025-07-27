import 'package:flutter/material.dart';

class ColorSchemes {
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Colors.black,
    secondary: Colors.green.shade700,
    onSecondary: Colors.grey[600]!,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.green,
    onPrimary: Colors.white,
    secondary: Colors.green.shade300,
    onSecondary: Colors.grey[600]!,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
  );
}
