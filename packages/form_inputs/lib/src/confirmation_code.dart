import 'package:formz/formz.dart';

/// User Confirmation Code Form Input Validation Error
enum ConfirmationCodeValidationError {
  /// Confirmation code is invalid (generic validation error)
  invalid
}

/// {@template confirmation_code_name}
/// Reusable confirmation code form input.
/// {@endtemplate}
class ConfirmationCode
    extends FormzInput<String, ConfirmationCodeValidationError> {
  /// {@macro confirmation_code_name}
  const ConfirmationCode.pure() : super.pure('');

  /// {@macro confirmation_code_name}
  const ConfirmationCode.dirty([super.value = '']) : super.dirty();

  @override
  ConfirmationCodeValidationError? validator(
    String value,
  ) {
    return value.length > 3 && value.isNotEmpty
        ? null
        : ConfirmationCodeValidationError.invalid;
  }
}
