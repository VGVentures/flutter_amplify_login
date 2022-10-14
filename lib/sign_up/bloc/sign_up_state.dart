// ignore_for_file: public_member_api_docs,
part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;

  @override
  List<Object> get props => [email, password, status, isValid];

  SignUpState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}
