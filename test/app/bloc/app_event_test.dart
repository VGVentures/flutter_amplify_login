// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:auth_client/auth_client.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEvent', () {
    group('AppUserChanged', () {
      test('supports value comparisons', () {
        expect(
          AppAuthStatusChanged(AuthStatus.authenticated),
          AppAuthStatusChanged(AuthStatus.authenticated),
        );
      });
    });

    group('AppSignOutRequested', () {
      test('supports value comparisons', () {
        expect(
          AppSignOutRequested(),
          AppSignOutRequested(),
        );
      });
    });
  });
}
