import 'package:flutter/material.dart';

/// Defines the color palette for the App UI.
/// Chosen from here https://m2.material.io/resources/color/#!/?view.left=0&view.right=0&primary.color=FF9800
abstract class AppColors {
  /// Black.
  static const Color black = Colors.black;

  /// Transparent.
  static const Color transparent = Colors.transparent;

  /// White.
  static const Color white = Colors.white;

  /// The primary color.
  static const Color primary = Color(0xFFff9800);

  /// The primary light color.
  static const Color primaryLight = Color(0xFFffc947);

  /// The primary dark color.
  static const Color primaryDark = Color(0xFFc66900);

  /// The secondary color.
  static const Color secondary = Color(0xFF424242);

  /// The secondary light color.
  static const Color secondaryLight = Color(0xFF6d6d6d);

  /// The secondary dark color.
  static const Color secondaryDark = Color(0xFF1b1b1b);

  /// The primary foreground color.
  static const Color primaryForegroundColor = Colors.black;

  /// The primary foreground color.
  static const Color secondaryForegroundColor = Colors.white;

  /// The red wine color.
  static const Color redWine = Color(0xFF9A031E);

  /// The default disabled foreground color.
  static const Color disabledForeground = Color(0x611B1B1B);

  /// The default disabled button color.
  static const Color disabledButton = Color(0x1F000000);
}
