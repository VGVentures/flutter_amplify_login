// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppButton', () {
    final theme = AppTheme().themeData;

    testWidgets('renders button', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        Column(
          children: [
            AppButton(
              child: buttonText,
            ),
          ],
        ),
      );
      expect(find.byType(AppButton), findsNWidgets(1));
      expect(find.text('buttonText'), findsNWidgets(1));
    });

    testWidgets(
        'renders disabled button '
        'when `AppButton()` is called '
        'with onPressed equal to null', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton(
          child: buttonText,
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(widget.onPressed, null);
    });

    testWidgets(
        'renders enabled button '
        'when `AppButton()` is called '
        'with onPressed ', (tester) async {
      final buttonText = Text('buttonText');

      await tester.pumpApp(
        AppButton(
          child: buttonText,
          onPressed: () {},
        ),
        theme: theme,
      );

      final finder = find.byType(ElevatedButton);
      final widget = tester.widget(finder) as ElevatedButton;

      expect(widget.onPressed, isNotNull);
    });
  });
}
