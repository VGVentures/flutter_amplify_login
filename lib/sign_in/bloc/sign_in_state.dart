// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs,
part of 'sign_in_bloc.dart';

enum SignInStatus { initial, loading, success, failure, edit }

class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.status = SignInStatus.initial,
    this.isValid = false,
    this.isObscure = true,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus formStatus;
  final bool isValid;
  final SignInStatus status;
  final bool isObscure;

  @override
  List<Object> get props =>
      [email, password, formStatus, status, isValid, isObscure];

  SignInState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? formStatus,
    bool? isValid,
    SignInStatus? status,
    bool? isObscure,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
