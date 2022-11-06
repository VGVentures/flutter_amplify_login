// ignore_for_file: prefer_const_constructors

import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const confirmationCodeTest = '123456';
  const emailTest = 'test@gmail.com';

  group('ConfirmationCodeEvent', () {
    group('ConfirmationCodeChanged', () {
      test('supports value comparisons', () {
        expect(
          ConfirmationCodeChanged(confirmationCodeTest),
          ConfirmationCodeChanged(confirmationCodeTest),
        );
        expect(
          ConfirmationCodeChanged(''),
          isNot(ConfirmationCodeChanged(confirmationCodeTest)),
        );
      });
    });

    group('ConfirmationCodeSubmitted', () {
      test('supports value comparisons', () {
        expect(
          ConfirmationCodeSubmitted(emailTest, confirmationCodeTest),
          ConfirmationCodeSubmitted(emailTest, confirmationCodeTest),
        );
      });
    });
  });
}
