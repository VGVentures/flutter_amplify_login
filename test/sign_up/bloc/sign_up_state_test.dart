// ignore_for_file: prefer_const_constructors
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';

void main() {
  const email = Email.dirty('email');
  const password = Password.dirty('password1234');

  group('SignUpState', () {
    test('supports value comparisons', () {
      expect(SignUpState(), SignUpState());
    });

    test('returns same object when no properties are passed', () {
      expect(SignUpState().copyWith(), SignUpState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        SignUpState().copyWith(status: SignUpStatus.initial),
        SignUpState(),
      );
    });

    test('returns object with updated formStatus when status is passed', () {
      expect(
        SignUpState().copyWith(formStatus: FormzSubmissionStatus.initial),
        SignUpState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        SignUpState().copyWith(email: email),
        SignUpState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        SignUpState().copyWith(password: password),
        SignUpState(password: password),
      );
    });

    test('returns object with updated isObscured when isObscured is passed',
        () {
      expect(
        SignUpState().copyWith(isObscure: false),
        SignUpState(isObscure: false),
      );
    });

    test('returns object with updated valid when valid is passed', () {
      expect(
        SignUpState().copyWith(isValid: true),
        SignUpState(isValid: true),
      );
    });
  });
}
