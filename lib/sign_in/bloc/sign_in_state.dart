// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs,
part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.valid = false,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool valid;

  @override
  List<Object> get props => [
        email,
        password,
        status,
        valid,
      ];

  SignInState copyWith({
    Email? email,
    Password? password,
    ConfirmationCode? confirmationCode,
    FormzSubmissionStatus? status,
    bool? valid,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
    );
  }
}
