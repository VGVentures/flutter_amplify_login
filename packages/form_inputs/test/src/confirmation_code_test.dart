// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  const confirmationCodeString = '123456';
  const confirmationCodeInvalidString = '12';

  group('ConfirmationCode', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final confirmationCode = ConfirmationCode.pure();
        expect(confirmationCode.value, '');
        expect(confirmationCode.isPure, true);
      });

      test('dirty creates correct instance', () {
        final confirmationCode = ConfirmationCode.dirty(confirmationCodeString);
        expect(confirmationCode.value, confirmationCodeString);
        expect(confirmationCode.isPure, false);
      });
    });

    group('validator', () {
      test('returns invalid error when confirmation code length is less than 3',
          () {
        expect(
          ConfirmationCode.dirty(confirmationCodeInvalidString).error,
          ConfirmationCodeValidationError.invalid,
        );
      });

      test('is valid when confirmation code is valid', () {
        expect(
          ConfirmationCode.dirty(confirmationCodeString).error,
          isNull,
        );
      });
    });
  });
}
