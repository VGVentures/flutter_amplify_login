import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<SignUpPasswordVisibilityToggled>(_onSignUpPasswordVisibilityToggled);
  }

  final UserRepository _userRepository;

  void _onEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      await _userRepository.signUp(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SignUpStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onSignUpPasswordVisibilityToggled(
    SignUpPasswordVisibilityToggled event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(isObscure: !state.isObscure));
  }
}
