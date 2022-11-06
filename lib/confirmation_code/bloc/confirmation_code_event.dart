part of 'confirmation_code_bloc.dart';

abstract class ConfirmationCodeEvent extends Equatable {
  const ConfirmationCodeEvent();
}

class ConfirmationCodeChanged extends ConfirmationCodeEvent {
  const ConfirmationCodeChanged(this.confirmationCode);

  final String confirmationCode;

  @override
  List<Object?> get props => [confirmationCode];
}

class ConfirmationCodeSubmitted extends ConfirmationCodeEvent {
  const ConfirmationCodeSubmitted(
    this.email,
    this.confirmationCode,
  );

  final String email;
  final String confirmationCode;

  @override
  List<Object?> get props => [email, confirmationCode];
}
