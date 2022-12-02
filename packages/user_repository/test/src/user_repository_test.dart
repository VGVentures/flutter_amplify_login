// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthClient extends Mock implements AuthClient {}

void main() {
  late AuthClient authClient;
  late UserRepository userRepository;

  const email = 'email@test.com';
  const password = '1234Test';
  const confirmationCode = '123456789';

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

    group('signIn', () {
      test('completes successfully', () {
        when(
          () => authClient.signIn(email, password),
        ).thenAnswer((_) => Future.value());
        expect(
          userRepository.signIn(email: email, password: password),
          completes,
        );
      });

      test('throws SignInFailure when AuthenticationException', () {
        when(() => authClient.signIn(email, password))
            .thenThrow(AuthenticationException(''));
        expect(
          userRepository.signIn(email: email, password: password),
          throwsA(isA<SignInFailure>()),
        );
      });

      test('throws UserNotFoundFailure when UserDoesNotExistException', () {
        when(() => authClient.signIn(email, password))
            .thenThrow(UserDoesNotExistException(''));
        expect(
          userRepository.signIn(email: email, password: password),
          throwsA(isA<UserDoesNotExistException>()),
        );
      });
    });

    group('signUp', () {
      test('completes successfully', () {
        when(
          () => authClient.signUp(email, password),
        ).thenAnswer((_) => Future.value());
        expect(
          userRepository.signUp(
            email: email,
            password: password,
          ),
          completes,
        );
      });

      test('throws UserAlreadyExistsFailure when UserAlreadyExistException',
          () {
        when(
          () => authClient.signUp(email, password),
        ).thenThrow(UserAlreadyExistException(''));
        expect(
          userRepository.signUp(
            email: email,
            password: password,
          ),
          throwsA(isA<UserAlreadyExistException>()),
        );
      });

      test('throws SignUpFailure when AuthenticationException', () {
        when(
          () => authClient.signUp(email, password),
        ).thenThrow(AuthenticationException(''));
        expect(
          userRepository.signUp(
            email: email,
            password: password,
          ),
          throwsA(isA<SignUpFailure>()),
        );
      });
    });
  });

  group('confirmSignUp', () {
    test('completes successfully', () {
      when(
        () => authClient.confirmSignUp(email, confirmationCode),
      ).thenAnswer((_) => Future.value());
      expect(
        userRepository.confirmSignUp(
          email: email,
          confirmationCode: confirmationCode,
        ),
        completes,
      );
    });

    test('throws ConfirmationCodeSignUpFailure when AuthenticationException',
        () {
      when(
        () => authClient.confirmSignUp(email, confirmationCode),
      ).thenThrow(AuthenticationException(''));
      expect(
        userRepository.confirmSignUp(
          email: email,
          confirmationCode: confirmationCode,
        ),
        throwsA(isA<ConfirmationCodeSignUpFailure>()),
      );
    });
  });

  group('signOut', () {
    test('completes successfully', () {
      when(
        () => authClient.signOut(),
      ).thenAnswer((_) => Future.value());
      expect(userRepository.signOut(), completes);
    });

    test('throws SignOutFailure when AuthenticationException', () {
      when(() => authClient.signOut()).thenThrow(AuthenticationException(''));
      expect(
        userRepository.signOut(),
        throwsA(isA<SignOutFailure>()),
      );
    });
  });

  group('authStatus', () {
    setUp(() {
      when(() => authClient.authStatus).thenAnswer((_) => Stream.empty());
    });

    test(
        'does not emit any state if AuthClient.authStatus '
        'does not emit anything', () {
      expect(
        userRepository.authStatus,
        emitsInOrder(<AuthStatus>[]),
      );
    });

    test('emits authenticated', () {
      when(() => authClient.authStatus)
          .thenAnswer((_) => Stream.value(AuthStatus.authenticated));
      expect(
        userRepository.authStatus,
        emitsInOrder(<AuthStatus>[AuthStatus.authenticated]),
      );
    });

    test('emits unauthenticated', () {
      when(() => authClient.authStatus)
          .thenAnswer((_) => Stream.value(AuthStatus.unauthenticated));
      expect(
        userRepository.authStatus,
        emitsInOrder(<AuthStatus>[AuthStatus.unauthenticated]),
      );
    });

    test('emits unauthenticated', () {
      when(() => authClient.authStatus)
          .thenAnswer((_) => Stream.value(AuthStatus.unauthenticated));
      expect(
        userRepository.authStatus,
        emitsInOrder(<AuthStatus>[AuthStatus.unauthenticated]),
      );
    });
  });

  group('isUserAuthenticated', () {
    test('returns true if user authenticated', () {
      when(() => authClient.isUserAuthenticated())
          .thenAnswer((_) async => true);
      expect(
        userRepository.isUserAuthenticated(),
        completion(true),
      );
    });

    test('returns false if user is not authenticated', () {
      when(() => authClient.isUserAuthenticated())
          .thenAnswer((_) async => false);
      expect(
        userRepository.isUserAuthenticated(),
        completion(false),
      );
    });

    test('returns false if any exception is thrown', () {
      when(() => authClient.isUserAuthenticated()).thenThrow(Exception());
      expect(
        userRepository.isUserAuthenticated(),
        completion(false),
      );
    });
  });
}
