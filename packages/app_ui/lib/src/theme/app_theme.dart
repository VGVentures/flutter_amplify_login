import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      primaryColor: _primaryColor,
      canvasColor: _backgroundColor,
      backgroundColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
      iconTheme: _iconTheme,
      appBarTheme: _appBarTheme,
      inputDecorationTheme: _inputDecorationTheme,
      snackBarTheme: _snackBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      colorScheme: _colorScheme,
    );
  }

  Color get _primaryColor => AppColors.primary;

  Color get _backgroundColor => AppColors.white;

  ColorScheme get _colorScheme {
    return const ColorScheme.light(secondary: AppColors.secondary);
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      iconTheme: _iconTheme,
      elevation: 1,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.black,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  IconThemeData get _iconTheme {
    return const IconThemeData(
      color: AppColors.black,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      suffixIconColor: AppColors.primaryDark,
      prefixIconColor: AppColors.primaryDark,
      hoverColor: AppColors.primaryDark,
      focusColor: AppColors.primaryDark,
      fillColor: _backgroundColor,
      enabledBorder: _textFieldBorder,
      focusedBorder: _textFieldBorder,
      disabledBorder: _textFieldBorder,
      errorBorder: _textFieldErrorBorder,
      contentPadding: const EdgeInsets.all(AppSpacing.lg),
      border: const UnderlineInputBorder(),
      filled: true,
      isDense: true,
    );
  }

  InputBorder get _textFieldBorder => OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: _primaryColor,
        ),
      );

  InputBorder get _textFieldErrorBorder => const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: AppColors.redWine,
        ),
      );

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      ),
    );
  }

  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.primary,
      backgroundColor: AppColors.secondary,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }
}

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  Color get _primaryColor => AppColors.secondaryLight;

  @override
  Color get _backgroundColor => AppColors.secondaryDark;

  @override
  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.primary);
  }

  @override
  ColorScheme get _colorScheme {
    return const ColorScheme.dark().copyWith(
      primary: AppColors.white,
      secondary: AppColors.secondary,
    );
  }

  @override
  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.primary,
      backgroundColor: AppColors.secondaryLight,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }
}
