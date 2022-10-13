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
import 'package:rxdart/subjects.dart';

/// {@template auth_exception}
/// Abstract class to handle the amplify auth exceptions.
/// {@endtemplate}
abstract class AuthException implements Exception {
  /// {@macro auth_exception}
  const AuthException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template sign_up_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpFailure extends AuthException {
  /// {@macro sign_up_failure}
  const SignUpFailure(super.error);
}

/// {@template confirmarion_code_sign_up_failure}
/// Thrown during the verification of the confiramtion code
/// sign up process if a failure occurs.
/// {@endtemplate}
class ConfirmationCodeSignUpFailure extends AuthException {
  /// {@macro confirmarion_code_sign_up_failure}
  const ConfirmationCodeSignUpFailure(super.error);
}

/// {@template sign_in_failure}
/// Thrown during the sign in process if a failure occurs.
/// {@endtemplate}
class SignInFailure extends AuthException {
  /// {@macro sign_in_failure}
  const SignInFailure(super.error);
}

/// {@template sign_out_failure}
/// Thrown during the sign out process if a failure occurs.
/// {@endtemplate}
class SignOutFailure extends AuthException {
  /// {@macro sign_out_failure}
  const SignOutFailure(super.error);
}

/// {@template auth_client}
/// AWS Amplify auth client
/// {@endtemplate}
class AuthClient {
  /// {@macro auth_client}
  AuthClient({
    required AuthCategory auth,
    required AmplifyHub hub,
  })  : _auth = auth,
        _hub = hub;

  final AuthCategory _auth;
  final AmplifyHub _hub;
  final _controller = BehaviorSubject<AmplifyUser>();

  /// Returns a stream of the current amplify user.
  Stream<AmplifyUser> get user {
    _hub.listen([HubChannel.Auth], (hubEvent) async {
      if (hubEvent.eventName.isSignedIn) {
        final user = await _auth.getCurrentUser();
        _controller.add(
          AmplifyUser(id: user.userId, email: user.username),
        );
      } else if (hubEvent.eventName.isSignedOut) {
        _controller.add(AmplifyUser.anonymous);
      } else {
        await _controller.close();
      }
    });

    return _controller.stream;
  }

  /// Creates a new user with the [email] and [password] variables.
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
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  /// Confirm the sign up with a confirmation code.
  Future<void> confirmSignUp(String email, String confirmationCode) async {
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
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signIn(
        username: email,
        password: password,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInFailure(error), stackTrace);
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignOutFailure(error), stackTrace);
    }
  }
}

/// Extension to get HubEvent names.
extension HubEventNameX on String {
  /// Wether is signed in.
  bool get isSignedIn => this == 'SIGNED_IN';

  /// Wether is signed out.
  bool get isSignedOut => this == 'SIGNED_OUT';
}
