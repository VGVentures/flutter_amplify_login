// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:auth_client/auth_client.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUser extends Mock implements AmplifyUser {}

void main() {
  group('AppEvent', () {
    group('AppUserChanged', () {
      final user = _MockUser();

      test('supports value comparisons', () {
        expect(
          AppUserChanged(user),
          AppUserChanged(user),
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
