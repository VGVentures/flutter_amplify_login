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

  /// Stream of [AuthStatus] which will emit the current user status when
  /// the authentication state changes.
  ///
  /// Emits [AuthStatus.unauthenticated] if the user is not authenticated.
  Stream<AuthStatus> get authStatus => _authClient.authStatus;

  /// Starts the Sign Up flow.
  ///
  /// Throws a [SignUpFailure] if [AuthenticationException] occurs.
  /// Throws a [UserAlreadyExistException] if [UserAlreadyExistException]
  /// occurs.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _authClient.signUp(email, password);
    } on UserAlreadyExistException catch (error, stackTrace) {
      Error.throwWithStackTrace(UserAlreadyExistException(error), stackTrace);
    } on AuthenticationException catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  /// Starts the Sign In flow.
  ///
  /// Throws a [SignInFailure] if [AuthenticationException] occurs.
  /// Throws a [UserDoesNotExistException]
  /// if [UserDoesNotExistException] occurs.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _authClient.signIn(email, password);
    } on UserDoesNotExistException catch (error, stackTrace) {
      Error.throwWithStackTrace(UserDoesNotExistException(error), stackTrace);
    } on AuthenticationException catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInFailure(error), stackTrace);
    }
  }

  /// Starts the Sign Out flow.
  ///
  /// Throws a [SignOutFailure] if an [AuthenticationException] occurs.
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
    } on AuthenticationException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SignOutFailure(error),
        stackTrace,
      );
    }
  }

  /// Starts the Confirmation Sign Up flow.
  ///
  /// Throws a [ConfirmationCodeSignUpFailure] if an [AuthenticationException]
  /// occurs.
  Future<void> confirmSignUp({
    required String email,
    required String confirmationCode,
  }) async {
    try {
      await _authClient.confirmSignUp(email, confirmationCode);
    } on AuthenticationException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ConfirmationCodeSignUpFailure(error),
        stackTrace,
      );
    }
  }

  /// Returns whether the user is authenticated or not.
  ///
  /// Returns `false` if an exception occurs.
  Future<bool> isUserAuthenticated() async {
    try {
      return _authClient.isUserAuthenticated();
    } catch (_) {
      return false;
    }
  }
}
