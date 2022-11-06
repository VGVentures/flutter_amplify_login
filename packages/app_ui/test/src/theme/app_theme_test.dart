// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    group('themeData', () {
      group('color', () {
        test('primary is AppColors.primary', () {
          expect(
            const AppTheme().themeData.primaryColor,
            AppColors.primary,
          );
        });

        test('secondary is AppColors.secondary', () {
          expect(
            const AppTheme().themeData.colorScheme.secondary,
            AppColors.secondary,
          );
        });
      });

      group('InputDecorationTheme', () {
        test('enabledBorder border color is AppColors.primary', () {
          expect(
            AppTheme().themeData.inputDecorationTheme.enabledBorder,
            OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: AppColors.primary,
              ),
            ),
          );
        });

        test('focusedBorder border color is AppColors.primary', () {
          expect(
            AppTheme().themeData.inputDecorationTheme.focusedBorder,
            OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: AppColors.primary,
              ),
            ),
          );
        });

        test('enabledBorder border color is AppColors.redWine', () {
          expect(
            AppTheme().themeData.inputDecorationTheme.errorBorder,
            OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: AppColors.redWine,
              ),
            ),
          );
        });
      });
    });

    group('AppDarkTheme', () {
      group('themeData', () {
        group('color', () {
          test('primary is AppColors.secondaryLight', () {
            expect(
              const AppDarkTheme().themeData.primaryColor,
              AppColors.secondaryLight,
            );
          });

          test('secondary is AppColors.secondary', () {
            expect(
              const AppDarkTheme().themeData.colorScheme.secondary,
              AppColors.secondary,
            );
          });

          test('background is AppColors.secondaryDark', () {
            expect(
              const AppDarkTheme().themeData.backgroundColor,
              AppColors.secondaryDark,
            );
          });
        });
      });
    });
  });
}
