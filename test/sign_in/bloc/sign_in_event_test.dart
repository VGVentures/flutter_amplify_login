// ignore_for_file: prefer_const_constructors

import 'package:flutter_amplify_login/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const passwordTest = 'passwordTest12345';
  const emailTest = 'test@gmail.com';

  group('SignInEvent', () {
    group('SignInEmailChanged', () {
      test('supports value comparisons', () {
        expect(
          SignInEmailChanged(emailTest),
          SignInEmailChanged(emailTest),
        );
        expect(
          SignInEmailChanged(''),
          isNot(SignInEmailChanged(emailTest)),
        );
      });
    });

    group('SignInPasswordChanged', () {
      test('supports value comparisons', () {
        expect(
          SignInPasswordChanged(passwordTest),
          SignInPasswordChanged(passwordTest),
        );
        expect(
          SignInPasswordChanged(''),
          isNot(SignInPasswordChanged(passwordTest)),
        );
      });
    });

    group('SignInSubmitted', () {
      test('supports value comparisons', () {
        expect(
          SignInSubmitted(emailTest, passwordTest),
          SignInSubmitted(emailTest, passwordTest),
        );
      });
    });

    group('SignInPasswordVisibilityToggled', () {
      test('supports value comparisons', () {
        expect(
          SignInPasswordVisibilityToggled(),
          SignInPasswordVisibilityToggled(),
        );
      });
    });
  });
}
