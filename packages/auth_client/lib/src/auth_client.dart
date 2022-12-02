// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// ignore: implementation_imports
import 'package:amplify_flutter/src/amplify_hub.dart';
import 'package:auth_client/auth_client.dart';

/// Enum indicating the Authentication status
enum AuthStatus {
  /// Authenticated session
  authenticated,

  /// Unauthenticated session
  unauthenticated,
}

/// {@template auth_client}
/// AWS Amplify auth client.
/// {@endtemplate}
class AuthClient {
  /// {@macro auth_client}
  AuthClient({
    required AuthCategory auth,
    required AmplifyHub hub,
  })  : _auth = auth,
        _hub = hub {
    _hub.listen([HubChannel.Auth], _onHubEvent);
  }

  final AuthCategory _auth;
  final AmplifyHub _hub;
  final _controller = StreamController<AuthStatus>();

  /// Stream current [AuthStatus]
  Stream<AuthStatus> get authStatus => _controller.stream;

  void _onHubEvent(dynamic hubEvent) {
    if (hubEvent is HubEvent) {
      switch (hubEvent.eventName) {
        case 'SIGNED_IN':
          _controller.add(AuthStatus.authenticated);
          break;
        case 'SIGNED_OUT':
        case 'SESSION_EXPIRED':
          _controller.add(AuthStatus.unauthenticated);
          break;
      }
    }
  }

  /// Returns whether the user is authenticated or not
  ///
  ///Throws a [FetchAuthenticatedUserFailure] if an exception occurs.
  Future<bool> isUserAuthenticated() async {
    try {
      final currentSesion = await _auth.fetchAuthSession();
      return currentSesion.isSignedIn;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchAuthenticatedUserFailure(error),
        stackTrace,
      );
    }
  }

  /// Creates a new user with the [email] and [password] variables.
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  /// Throws a [UserAlreadyExistException] if email already exists.
  Future<void> signUp(
    String email,
    String password,
  ) async {
    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: email,
      };
      final options = CognitoSignUpOptions(userAttributes: userAttributes);

      await _auth.signUp(
        username: email,
        password: password,
        options: options,
      );
    } on UsernameExistsException catch (error, stackTrace) {
      Error.throwWithStackTrace(UserAlreadyExistException(error), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  /// Confirm the sign up with a confirmation code.
  Future<void> confirmSignUp(
    String email,
    String confirmationCode,
  ) async {
    try {
      await _auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ConfirmationCodeSignUpFailure(error),
        stackTrace,
      );
    }
  }

  /// Sign in with the provided [email] and [password].
  ///
  /// Throws a [UserDoesNotExistException] if [UserNotFoundException] occurs
  /// (provided email is not correct).
  /// Throws a [UserDoesNotExistException] if [NotAuthorizedException] occurs.
  /// (provided email is correct, but the password isn't, or vice versa).
  /// Throws a [SignInFailure] if an exception occurs.
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signIn(
        username: email,
        password: password,
      );
    } on UserNotFoundException catch (error, stackTrace) {
      Error.throwWithStackTrace(UserDoesNotExistException(error), stackTrace);
    } on NotAuthorizedException catch (error, stackTrace) {
      Error.throwWithStackTrace(UserNotAuthorizedException(error), stackTrace);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInFailure(error), stackTrace);
    }
  }

  /// Sign out the current user.
  ///
  /// Throws a [SignOutFailure] if an exception occurs.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignOutFailure(error), stackTrace);
    }
  }
}
