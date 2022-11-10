// ignore_for_file: prefer_const_constructors
import 'package:flutter_amplify_login/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';

void main() {
  const email = Email.dirty('email');
  const password = Password.dirty('password1234');

  group('SignInState', () {
    test('supports value comparisons', () {
      expect(SignInState(), SignInState());
    });

    test('returns same object when no properties are passed', () {
      expect(SignInState().copyWith(), SignInState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        SignInState().copyWith(status: SignInStatus.initial),
        SignInState(),
      );
    });

    test('returns object with updated formStatus when status is passed', () {
      expect(
        SignInState().copyWith(formStatus: FormzSubmissionStatus.initial),
        SignInState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        SignInState().copyWith(email: email),
        SignInState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        SignInState().copyWith(password: password),
        SignInState(password: password),
      );
    });

    test('returns object with updated isObscured when isObscured is passed',
        () {
      expect(
        SignInState().copyWith(isObscure: false),
        SignInState(isObscure: false),
      );
    });

    test('returns object with updated valid when isValid is passed', () {
      expect(
        SignInState().copyWith(isValid: true),
        SignInState(isValid: true),
      );
    });
  });
}
