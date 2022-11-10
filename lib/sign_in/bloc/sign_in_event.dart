part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInEmailChanged extends SignInEvent {
  const SignInEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignInSubmitted extends SignInEvent {
  const SignInSubmitted(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignInPasswordVisibilityToggled extends SignInEvent {
  const SignInPasswordVisibilityToggled();

  @override
  List<Object?> get props => [];
}
