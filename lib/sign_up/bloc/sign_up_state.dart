part of 'sign_up_bloc.dart';

enum SignUpStatus { initial, loading, success, failure, edit }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.formStatus = FormzSubmissionStatus.initial,
    this.status = SignUpStatus.initial,
    this.isValid = false,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus formStatus;
  final SignUpStatus status;
  final bool isValid;

  @override
  List<Object> get props => [
        email,
        password,
        formStatus,
        status,
        isValid,
      ];

  SignUpState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? formStatus,
    SignUpStatus? status,
    bool? isValid,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}
