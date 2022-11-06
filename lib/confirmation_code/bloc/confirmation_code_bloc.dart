import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'confirmation_code_event.dart';
part 'confirmation_code_state.dart';

class ConfirmationCodeBloc
    extends Bloc<ConfirmationCodeEvent, ConfirmationCodeState> {
  ConfirmationCodeBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ConfirmationCodeState()) {
    on<ConfirmationCodeChanged>(_onConfirmationCodeChanged);
    on<ConfirmationCodeSubmitted>(_onConfirmationCodeSubmitted);
  }

  final UserRepository _userRepository;

  void _onConfirmationCodeChanged(
    ConfirmationCodeChanged event,
    Emitter<ConfirmationCodeState> emit,
  ) {
    final confirmationCode = ConfirmationCode.dirty(event.confirmationCode);
    emit(
      state.copyWith(
        confirmationCode: confirmationCode,
        isValid: Formz.validate([confirmationCode]),
      ),
    );
  }

  Future<void> _onConfirmationCodeSubmitted(
    ConfirmationCodeSubmitted event,
    Emitter<ConfirmationCodeState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.confirmSignUp(
        email: event.email,
        confirmationCode: event.confirmationCode,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
