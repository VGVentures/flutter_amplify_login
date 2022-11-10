// ignore_for_file: prefer_const_constructors

import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const passwordTest = 'passwordTest12345';
  const emailTest = 'test@gmail.com';

  group('SignUpEvent', () {
    group('SignUpEmailChanged', () {
      test('supports value comparisons', () {
        expect(
          SignUpEmailChanged(emailTest),
          SignUpEmailChanged(emailTest),
        );
        expect(
          SignUpEmailChanged(''),
          isNot(SignUpEmailChanged(emailTest)),
        );
      });
    });

    group('SignUpPasswordChanged', () {
      test('supports value comparisons', () {
        expect(
          SignUpPasswordChanged(passwordTest),
          SignUpPasswordChanged(passwordTest),
        );
        expect(
          SignUpPasswordChanged(''),
          isNot(SignUpPasswordChanged(passwordTest)),
        );
      });
    });

    group('SignUpSubmitted', () {
      test('supports value comparisons', () {
        expect(
          SignUpSubmitted(emailTest, passwordTest),
          SignUpSubmitted(emailTest, passwordTest),
        );
      });
    });

    group('SignUpPasswordVisibilityToggled', () {
      test('supports value comparisons', () {
        expect(
          SignUpPasswordVisibilityToggled(),
          SignUpPasswordVisibilityToggled(),
        );
      });
    });
  });
}
