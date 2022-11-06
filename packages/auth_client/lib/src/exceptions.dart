/// {@template auth_exception}
/// Abstract class to handle the amplify auth exceptions.
/// {@endtemplate}
class AuthenticationException implements Exception {
  /// {@macro auth_exception}
  const AuthenticationException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template sign_up_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpFailure extends AuthenticationException {
  /// {@macro sign_up_failure}
  const SignUpFailure(super.error);
}

/// {@template confirmarion_code_sign_up_failure}
/// Thrown during the verification of the confiramtion code
/// sign up process if a failure occurs.
/// {@endtemplate}
class ConfirmationCodeSignUpFailure extends AuthenticationException {
  /// {@macro confirmarion_code_sign_up_failure}
  const ConfirmationCodeSignUpFailure(super.error);
}

/// {@template sign_in_failure}
/// Thrown during the sign in process if a failure occurs.
/// {@endtemplate}
class SignInFailure extends AuthenticationException {
  /// {@macro sign_in_failure}
  const SignInFailure(super.error);
}

/// {@template sign_out_failure}
/// Thrown during the sign out process if a failure occurs.
/// {@endtemplate}
class SignOutFailure extends AuthenticationException {
  /// {@macro sign_out_failure}
  const SignOutFailure(super.error);
}

/// {@template fetch_authenticated_user_failure}
/// Thrown during the fetching authenticated user process if a failure occurs.
/// {@endtemplate}
class FetchAuthenticatedUserFailure extends AuthenticationException {
  /// {@macro fetch_authenticated_user_failure}
  const FetchAuthenticatedUserFailure(super.error);
}

/// {@template user_already_exits_failure}
/// Throw when signup is not completed because email already exists.
/// {@endtemplate}
class UserAlreadyExistException extends AuthenticationException {
  /// {@macro user_already_exits_failure}
  const UserAlreadyExistException(super.error);
}

/// {@template user_does_not_exits_failure}
/// Throw when signup is not completed because email already exists.
/// {@endtemplate}
class UserDoesNotExistException extends AuthenticationException {
  /// {@macro user_does_not_exits_failure}
  const UserDoesNotExistException(super.error);
}

/// {@template user_not_authorized_failure}
/// Throw when sign in is not completed because user is not authorized.
/// {@endtemplate}
class UserNotAuthorizedException extends AuthenticationException {
  /// {@macro user_not_authorized_failure}
  const UserNotAuthorizedException(super.error);
}
