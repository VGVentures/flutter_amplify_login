// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_bloc.dart';

enum SignUpStatus { initial, loading, success, failure, edit }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.status = SignUpStatus.initial,
    this.isValid = false,
    this.isObscure = true,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus formStatus;
  final SignUpStatus status;
  final bool isValid;
  final bool isObscure;

  @override
  List<Object> get props => [
        email,
        password,
        formStatus,
        status,
        isValid,
        isObscure,
      ];

  SignUpState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? formStatus,
    SignUpStatus? status,
    bool? isValid,
    bool? isObscure,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
