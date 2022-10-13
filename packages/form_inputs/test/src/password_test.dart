// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/src/password.dart';
import 'package:test/test.dart';

void main() {
  const passwordValidString = 'testPassword1234';
  const passwordInvalidString = 'test1';

  group('Password', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final password = Password.pure();
        expect(password.value, '');
        expect(password.isPure, true);
      });

      test('dirty creates correct instance', () {
        final password = Password.dirty(passwordValidString);
        expect(password.value, passwordValidString);
        expect(password.isPure, false);
      });
    });

    group('validator', () {
      test('returns invalid error when password is empty', () {
        expect(
          Password.dirty().error,
          PasswordValidationError.invalid,
        );
      });

      test('returns invalid error when password is malformed', () {
        expect(
          Password.dirty(passwordInvalidString).error,
          PasswordValidationError.invalid,
        );
      });

      test('is valid when password is valid', () {
        expect(
          Password.dirty(passwordValidString).error,
          isNull,
        );
      });
    });
  });
}
