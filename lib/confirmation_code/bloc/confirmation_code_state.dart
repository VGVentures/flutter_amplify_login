part of 'confirmation_code_bloc.dart';

class ConfirmationCodeState extends Equatable {
  const ConfirmationCodeState({
    this.confirmationCode = const ConfirmationCode.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final ConfirmationCode confirmationCode;
  final FormzSubmissionStatus status;
  final bool isValid;

  @override
  List<Object> get props => [
        confirmationCode,
        status,
        isValid,
      ];

  ConfirmationCodeState copyWith({
    ConfirmationCode? confirmationCode,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return ConfirmationCodeState(
      confirmationCode: confirmationCode ?? this.confirmationCode,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}
