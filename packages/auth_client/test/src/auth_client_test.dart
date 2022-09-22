// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAmplifyAuth extends Mock implements AuthCategory {}

class _FakeSignInResult extends Fake implements SignInResult {}

class _FakeSignUpResult extends Fake implements SignUpResult {}

class _FakeSignOutResult extends Fake implements SignOutResult {}

void main() {
  late AuthClient authClient;
  late AuthCategory auth;
  late SignInResult signInResultResponse;
  late SignUpResult signUpResultResponse;
  late SignOutResult signOutResultResponse;

  const email = 'test@test.com';
  const password = 'Password';

  setUp(() {
    auth = _MockAmplifyAuth();
    signInResultResponse = _FakeSignInResult();
    signUpResultResponse = _FakeSignUpResult();
    signOutResultResponse = _FakeSignOutResult();
    authClient = AuthClient(auth: auth);
  });
  group('AuthClient', () {
    test('can be instantiated', () {
      expect(AuthClient(auth: auth), isNotNull);
    });

    group('SignIn', () {
      test('completes', () async {
        when(
          () => auth.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => signInResultResponse,
        );

        expect(authClient.signIn(email, password), completes);
      });

      test('throw SignInFailure', () async {
        when(
          () => auth.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow((_) async => Exception());

        expect(
          authClient.signIn(email, password),
          throwsA(isA<SignInFailure>()),
        );
      });
    });

    group('SignUp', () {
      test('completes', () async {
        when(
          () => auth.signUp(
            username: any(named: 'username'),
            password: any(named: 'password'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => signUpResultResponse,
        );

        expect(authClient.signUp(email, password), completes);
      });

      test('throw SignUpFailure', () async {
        when(
          () => auth.signIn(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow((_) async => Exception());

        expect(
          authClient.signUp(email, password),
          throwsA(isA<SignUpFailure>()),
        );
      });
    });

    group('SignOut', () {
      test('completes', () async {
        when(
          () => auth.signOut(),
        ).thenAnswer(
          (_) async => signOutResultResponse,
        );

        expect(authClient.signOut(), completes);
      });

      test('throw SignOutFailure', () async {
        when(
          () => auth.signOut(),
        ).thenThrow((_) async => Exception());

        expect(
          authClient.signOut(),
          throwsA(isA<SignOutFailure>()),
        );
      });
    });

    group('ConfirmSignUp', () {
      test('completes', () async {
        when(
          () => auth.confirmSignUp(
            username: any(named: 'username'),
            confirmationCode: any(named: 'confirmationCode'),
          ),
        ).thenAnswer(
          (_) async => signUpResultResponse,
        );

        expect(authClient.confirmSignUp(email, password), completes);
      });

      test('throw ConfirmationCodeSignUpFailure', () async {
        when(
          () => auth.confirmSignUp(
            username: any(named: 'username'),
            confirmationCode: any(named: 'confirmationCode'),
          ),
        ).thenThrow((_) async => Exception());

        expect(
          authClient.confirmSignUp(email, password),
          throwsA(isA<ConfirmationCodeSignUpFailure>()),
        );
      });
    });
  });
}
