// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// ignore: implementation_imports
import 'package:amplify_flutter/src/amplify_hub.dart';
import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AuthHubEvent extends HubEvent {
  AuthHubEvent(super.eventName);
}

class _FakeSignInResult extends Fake implements SignInResult {}

class _FakeSignOutResult extends Fake implements SignOutResult {}

class _MockAuthCategory extends Mock implements AuthCategory {}

class _FakeSignUpResult extends Fake implements SignUpResult {
  @override
  bool isSignUpComplete = true;
}

class FakeCognitoSignUpOptions extends Fake implements CognitoSignUpOptions {}

class _FakeAmplifyHub extends Fake implements AmplifyHub {
  @override
  StreamSubscription<HubEvent> listen(
    List<HubChannel> channels,
    Listener listener,
  ) {
    return _controller.stream.listen(listener);
  }

  void addEventTest(HubEvent event) {
    _controller.add(event);
  }

  final StreamController<HubEvent> _controller = StreamController<HubEvent>();
}

void main() {
  late AuthClient authClient;
  late AuthCategory authCategory;
  late _FakeAmplifyHub amplifyHub;

  const email = 'test@test.com';
  const password = 'Password';
  const confirmationCode = 'code';

  setUp(() {
    authCategory = _MockAuthCategory();
    amplifyHub = _FakeAmplifyHub();
    authClient = AuthClient(
      auth: authCategory,
      hub: amplifyHub,
    );
  });

  group('AuthClient', () {
    group('signIn', () {
      test('completes successfully', () {
        when(
          () => authCategory.signIn(
            username: email,
            password: password,
          ),
        ).thenAnswer((_) async => _FakeSignInResult());
        expect(
          authClient.signIn(email, password),
          completes,
        );
      });

      test('throws UserDoesNotExistException when UserNotFoundException', () {
        when(() => authCategory.signIn(username: email, password: password))
            .thenThrow(UserNotFoundException(''));
        expect(
          authClient.signIn(email, password),
          throwsA(isA<UserDoesNotExistException>()),
        );
      });

      test('throws UserDoesNotExistException when NotAuthorizedException', () {
        when(() => authCategory.signIn(username: email, password: password))
            .thenThrow(NotAuthorizedException(''));
        expect(
          authClient.signIn(email, password),
          throwsA(isA<UserNotAuthorizedException>()),
        );
      });

      test('throws SignInFailure when any exception happens', () {
        when(() => authCategory.signIn(username: email, password: password))
            .thenThrow(Exception());
        expect(
          authClient.signIn(email, password),
          throwsA(isA<SignInFailure>()),
        );
      });
    });
  });

  group('signUp', () {
    test('completes successfully', () {
      when(
        () => authCategory.signUp(
          username: email,
          password: password,
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => _FakeSignUpResult());
      expect(
        authClient.signUp(email, password),
        completes,
      );
    });

    test('throws UserAlreadyExistException when UsernameExistsException', () {
      when(
        () => authCategory.signUp(
          username: email,
          password: password,
          options: any(named: 'options'),
        ),
      ).thenThrow(UsernameExistsException(''));
      expect(
        authClient.signUp(email, password),
        throwsA(isA<UserAlreadyExistException>()),
      );
    });

    test('throws SignInFailure when any exception happens', () {
      when(
        () => authCategory.signUp(
          username: email,
          password: password,
          options: any(named: 'options'),
        ),
      ).thenThrow(Exception());
      expect(
        authClient.signUp(email, password),
        throwsA(isA<SignUpFailure>()),
      );
    });
  });

  group('confirmSignUp', () {
    test('completes successfully', () {
      when(
        () => authCategory.confirmSignUp(
          username: email,
          confirmationCode: confirmationCode,
        ),
      ).thenAnswer((_) async => _FakeSignUpResult());
      expect(
        authClient.confirmSignUp(email, confirmationCode),
        completes,
      );
    });

    test('throws ConfirmationCodeSignUpFailure when any exception happens', () {
      when(
        () => authCategory.confirmSignUp(
          username: email,
          confirmationCode: confirmationCode,
        ),
      ).thenThrow(Exception());
      expect(
        authClient.confirmSignUp(email, confirmationCode),
        throwsA(isA<ConfirmationCodeSignUpFailure>()),
      );
    });
  });

  group('signOut', () {
    test('completes successfully', () {
      when(() => authCategory.signOut())
          .thenAnswer((_) async => _FakeSignOutResult());
      expect(authClient.signOut(), completes);
    });

    test('throws SignOutFailure when any exception happens', () {
      when(() => authCategory.signOut()).thenThrow(Exception());
      expect(
        authClient.signOut,
        throwsA(isA<SignOutFailure>()),
      );
    });

    group('isUserAuthenticated', () {
      test('returns true if user is signed in', () {
        when(() => authCategory.fetchAuthSession())
            .thenAnswer((_) async => AuthSession(isSignedIn: true));
        expect(authClient.isUserAuthenticated(), completion(equals(true)));
      });

      test('returns false if user is not signed in', () {
        when(() => authCategory.fetchAuthSession())
            .thenAnswer((_) async => AuthSession(isSignedIn: false));
        expect(authClient.isUserAuthenticated(), completion(equals(false)));
      });

      test('throws FetchAuthenticatedUserFailure when any exception happens',
          () {
        when(() => authCategory.fetchAuthSession()).thenThrow(Exception());
        expect(
          authClient.isUserAuthenticated,
          throwsA(isA<FetchAuthenticatedUserFailure>()),
        );
      });
    });
  });

  group('AuthHubEvent', () {
    test('emits authenticated', () async {
      final amplifyHub = _FakeAmplifyHub();

      final authClient = AuthClient(
        auth: authCategory,
        hub: amplifyHub,
      );
      amplifyHub._controller.add(AuthHubEvent('SIGNED_IN'));

      await expectLater(
        authClient.authStatus,
        emitsInOrder(<AuthStatus>[AuthStatus.authenticated]),
      );
    });

    test('emits unauthenticated', () async {
      final amplifyHub = _FakeAmplifyHub();

      final authClient = AuthClient(
        auth: authCategory,
        hub: amplifyHub,
      );
      amplifyHub._controller.add(AuthHubEvent('SIGNED_OUT'));
      await expectLater(
        authClient.authStatus,
        emitsInOrder(<AuthStatus>[AuthStatus.unauthenticated]),
      );
    });

    test('emits unauthenticated', () async {
      final amplifyHub = _FakeAmplifyHub();

      final authClient = AuthClient(
        auth: authCategory,
        hub: amplifyHub,
      );
      amplifyHub._controller.add(AuthHubEvent('SESSION_EXPIRED'));
      await expectLater(
        authClient.authStatus,
        emitsInOrder(<AuthStatus>[AuthStatus.unauthenticated]),
      );
    });

    test('does not emit anything if any other HubEvent', () async {
      final amplifyHub = _FakeAmplifyHub();

      final authClient = AuthClient(
        auth: authCategory,
        hub: amplifyHub,
      );
      amplifyHub._controller.add(AuthHubEvent('OTHER'));
      await expectLater(
        authClient.authStatus,
        emitsInOrder(<AuthStatus>[]),
      );
    });
  });
}
