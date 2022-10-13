// ignore_for_file: public_member_api_docs,
part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
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
  List<Object> get props => [email, status, valid];

  SignUpState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? valid,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
    );
  }
}
