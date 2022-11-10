import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignInState()) {
    on<SignInEmailChanged>(_onEmailChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignInPasswordVisibilityToggled>(_onSignInPasswordVisibilityToggled);
  }

  final UserRepository _userRepository;

  void _onEmailChanged(
    SignInEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        status: SignInStatus.edit,
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        status: SignInStatus.edit,
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: SignInStatus.loading));
    try {
      await _userRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: SignInStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SignInStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onSignInPasswordVisibilityToggled(
    SignInPasswordVisibilityToggled event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(isObscure: !state.isObscure));
  }
}
