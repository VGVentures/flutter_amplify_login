// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auth_client/auth_client.dart';

/// {@template user_repository}
/// A package which manages the user domain
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required AuthClient authClient,
  }) : _authClient = authClient;

  final AuthClient _authClient;

  /// Stream of [AmplifyUser] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AmplifyUser.anonymous] if the user is not authenticated.
  Stream<AmplifyUser> get user => _authClient.user;

  /// Starts the Sign Up flow.
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _authClient.signUp(email, password);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  /// Starts the Sign In flow.
  ///
  /// Throws a [SignInFailure] if an exception occurs.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _authClient.signIn(email, password);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInFailure(error), stackTrace);
    }
  }

  /// Starts the Sign Out flow.
  ///
  /// Throws a [SignOutFailure] if an exception occurs.
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignOutFailure(error), stackTrace);
    }
  }

  /// Starts the Confirmation Sign Up flow.
  ///
  /// Throws a [ConfirmationCodeSignUpFailure] if an exception occurs.
  Future<void> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      await _authClient.confirmSignUp(email, confirmationCode);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ConfirmationCodeSignUpFailure(error),
        stackTrace,
      );
    }
  }
}
