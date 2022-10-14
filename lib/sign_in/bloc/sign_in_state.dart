// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs,
part of 'sign_in_bloc.dart';

enum SignInStatus {
  initial,
  signInLoading,
  signInFailure,
  signInSuccess,
  confirmationCodeLoading,
  confirmationCodeFailure,
  confirmarionCodeSuccess,
}

extension SignInStatusX on SignInStatus {
  bool get isInitial => this == SignInStatus.initial;
  bool get isSignInSuccess => this == SignInStatus.signInSuccess;
  bool get isSignInFailure => this == SignInStatus.signInFailure;
  bool get isSignInLoading => this == SignInStatus.signInLoading;
  bool get isConfirmationCodeSuccess =>
      this == SignInStatus.confirmarionCodeSuccess;
  bool get isConfirmationCodeFailure =>
      this == SignInStatus.confirmationCodeFailure;
  bool get isConfirmationCodeLoading =>
      this == SignInStatus.confirmationCodeLoading;
}

class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmationCode = const ConfirmationCode.pure(),
    this.status = SignInStatus.initial,
    this.valid = false,
  });

  final Email email;
  final Password password;
  final ConfirmationCode confirmationCode;
  final SignInStatus status;
  final bool valid;

  @override
  List<Object> get props => [
        email,
        password,
        confirmationCode,
        status,
        valid,
      ];

  SignInState copyWith({
    Email? email,
    Password? password,
    ConfirmationCode? confirmationCode,
    SignInStatus? status,
    bool? valid,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      status: status ?? this.status,
      valid: valid ?? this.valid,
    );
  }
}
