// ignore_for_file: prefer_const_constructors
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';

void main() {
  const confirmationCode = ConfirmationCode.dirty('12345');

  group('ConfirmationCodeState', () {
    test('supports value comparisons', () {
      expect(ConfirmationCodeState(), ConfirmationCodeState());
    });

    test('returns same object when no properties are passed', () {
      expect(ConfirmationCodeState().copyWith(), ConfirmationCodeState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        ConfirmationCodeState().copyWith(status: FormzSubmissionStatus.initial),
        ConfirmationCodeState(),
      );
    });

    test(
        'returns object with updated confirmationCode when '
        'confirmationCode is passed', () {
      expect(
        ConfirmationCodeState().copyWith(confirmationCode: confirmationCode),
        ConfirmationCodeState(confirmationCode: confirmationCode),
      );
    });

    test('returns object with updated valid when isValid is passed', () {
      expect(
        ConfirmationCodeState().copyWith(isValid: true),
        ConfirmationCodeState(isValid: true),
      );
    });
  });
}
