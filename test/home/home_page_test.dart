// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/home/view/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppPage', () {
    test('has a page', () {
      expect(HomePage.page(), isA<MaterialPage<void>>());
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpApp(HomePage());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
