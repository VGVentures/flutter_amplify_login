// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
// ignore: implementation_imports
import 'package:amplify_flutter/src/amplify_hub.dart';
import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

const email = 'test@test.com';
const password = 'Password';
const currentUserId = 'currentUserId';

class _MockAmplifyAuth extends Mock implements AuthCategory {}

class _MockSignInResult extends Mock implements SignInResult {}

class _MockSignUpResult extends Mock implements SignUpResult {}

class _FakeAuthUserResult extends Fake implements AuthUser {
  @override
  String userId = currentUserId;

  @override
  String username = email;
}

class _MockSignOutResult extends Mock implements SignOutResult {}

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

class _FakeHubEventSignedOut extends Fake implements HubEvent {
  @override
  final String eventName = 'SIGNED_OUT';
}

class _FakeHubEventSignedIn extends Fake implements HubEvent {
  @override
  final String eventName = 'SIGNED_IN';
}

class _FakeHubEventSessionExpired extends Fake implements HubEvent {
  @override
  final String eventName = 'SESSION_EXPIRED';
}

void main() {
  late AuthClient authClient;
  late AuthCategory auth;
  late SignInResult signInResultResponse;
  late SignUpResult signUpResultResponse;
  late SignOutResult signOutResultResponse;
  late HubEvent hubEventSignOut;
  late HubEvent hubEventSignIn;
  late HubEvent hubEventSessionExpired;

  late _FakeAmplifyHub amplifyHub;

  late AuthUser authUserResponse;

  setUp(() {
    auth = _MockAmplifyAuth();
    amplifyHub = _FakeAmplifyHub();
    authClient = AuthClient(
      auth: auth,
      hub: amplifyHub,
    );
  });

  group('AuthClient', () {
    test('can be instantiated', () {
      expect(
        AuthClient(
          auth: auth,
          hub: amplifyHub,
        ),
        isNotNull,
      );
    });

    group('SignIn', () {
      setUp(() {
        signInResultResponse = _MockSignInResult();
      });

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
      setUp(() {
        signUpResultResponse = _MockSignUpResult();
      });

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
      setUp(() {
        signOutResultResponse = _MockSignOutResult();
      });

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

    group('AmplifyUser', () {
      const user = AmplifyUser(
        id: currentUserId,
        email: email,
      );

      setUp(() {
        hubEventSignOut = _FakeHubEventSignedOut();
        hubEventSignIn = _FakeHubEventSignedIn();
        authUserResponse = _FakeAuthUserResult();
        hubEventSessionExpired = _FakeHubEventSessionExpired();
      });

      test('emits a AmplifyUser.anonymous when hub event is SIGNED_OUT',
          () async {
        amplifyHub.addEventTest(hubEventSignOut);
        await expectLater(
          authClient.user,
          emitsInOrder(<AmplifyUser>[AmplifyUser.anonymous]),
        );
      });

      test('emits a AmplifyUser when hub event is SIGNED_IN', () async {
        amplifyHub.addEventTest(hubEventSignIn);

        when(() => auth.getCurrentUser()).thenAnswer(
          (_) async => authUserResponse,
        );

        await expectLater(
          authClient.user,
          emitsInOrder(<AmplifyUser>[user]),
        );
      });

      test('emits nothing when hub event are not SIGNED_IN or SIGNED_OUT ',
          () async {
        amplifyHub.addEventTest(hubEventSessionExpired);

        await expectLater(
          authClient.user,
          emitsDone,
        );
      });
    });
  });
}
