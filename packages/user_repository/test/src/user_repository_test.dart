// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthClient extends Mock implements AuthClient {}

class FakeSignInFailure extends Fake implements SignInFailure {}

class FakeSignOutFailure extends Fake implements SignOutFailure {}

class FakeSignUpFailure extends Fake implements SignUpFailure {}

class FakeConfirmationCodeSignUpFailure extends Fake
    implements ConfirmationCodeSignUpFailure {}

class MockUser extends Mock implements AmplifyUser {}

const emailTest = 'emal@test.com';
const passwordTest = '1234Test';
const confirmationCodeTest = '123456789';

void main() {
  late AuthClient authClient;
  late UserRepository userRepository;

  setUp(() {
    authClient = _MockAuthClient();
    userRepository = UserRepository(
      authClient: authClient,
    );
  });

  group('UserRepository', () {
    test('can be instantiated', () {
      expect(
        UserRepository(
          authClient: authClient,
        ),
        isNotNull,
      );
    });

    group('user', () {
      test('calls user on AuthClient', () {
        when(() => authClient.user).thenAnswer(
          (_) => const Stream.empty(),
        );
        userRepository.user;
        verify(() => authClient.user).called(1);
      });
    });

    group('signIn', () {
      test('calls signIn on AuthClient', () async {
        when(
          () => authClient.signIn(emailTest, passwordTest),
        ).thenAnswer((_) async {});
        await userRepository.signIn(
          email: emailTest,
          password: passwordTest,
        );
        verify(() => authClient.signIn(emailTest, passwordTest)).called(1);
      });

      test('throws SignInFailure on generic exception', () async {
        when(
          () => authClient.signIn(emailTest, passwordTest),
        ).thenThrow(Exception());
        expect(
          () => userRepository.signIn(email: emailTest, password: passwordTest),
          throwsA(isA<SignInFailure>()),
        );
      });
    });

    group('signUp', () {
      test('calls signUp on AuthClient', () async {
        when(
          () => authClient.signUp(emailTest, passwordTest),
        ).thenAnswer((_) async {});
        await userRepository.signUp(
          email: emailTest,
          password: passwordTest,
        );
        verify(() => authClient.signUp(emailTest, passwordTest)).called(1);
      });

      test('throws SignInFailure on generic exception', () async {
        when(
          () => authClient.signUp(emailTest, passwordTest),
        ).thenThrow(Exception());
        expect(
          () => userRepository.signUp(email: emailTest, password: passwordTest),
          throwsA(isA<SignUpFailure>()),
        );
      });
    });

    group('signOut', () {
      test('calls signOut on AuthClient', () async {
        when(
          () => authClient.signOut(),
        ).thenAnswer((_) async {});
        await userRepository.signOut();
        verify(() => authClient.signOut()).called(1);
      });

      test('throws SignOutFailure on generic exception', () async {
        when(
          () => authClient.signOut(),
        ).thenThrow(Exception());
        expect(
          () => userRepository.signOut(),
          throwsA(isA<SignOutFailure>()),
        );
      });
    });

    group('confirmSignUp', () {
      test('calls confirmSignUp on AuthClient', () async {
        when(
          () => authClient.confirmSignUp(emailTest, confirmationCodeTest),
        ).thenAnswer((_) async {});
        await userRepository.confirmSignUp(
          email: emailTest,
          confirmationCode: confirmationCodeTest,
        );
        verify(() => authClient.confirmSignUp(emailTest, confirmationCodeTest))
            .called(1);
      });

      test('throws ConfirmationCodeSignUpFailure on generic exception',
          () async {
        when(
          () => authClient.confirmSignUp(emailTest, confirmationCodeTest),
        ).thenThrow(Exception());
        expect(
          () => userRepository.confirmSignUp(
            email: emailTest,
            confirmationCode: confirmationCodeTest,
          ),
          throwsA(isA<ConfirmationCodeSignUpFailure>()),
        );
      });
    });
  });
}
