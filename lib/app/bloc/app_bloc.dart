import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
    required bool isAuthenticated,
  })  : _userRepository = userRepository,
        super(
          isAuthenticated
              ? const AppState.authenticated()
              : const AppState.unauthenticated(),
        ) {
    on<AppAuthStatusChanged>(_onAuthStatusChanged);
    on<AppSignOutRequested>(_onSignOutRequested);

    _authStatusSubscription = _userRepository.authStatus.listen(
      _authStatusChanged,
    );
  }

  final UserRepository _userRepository;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  void _authStatusChanged(AuthStatus authStatus) =>
      add(AppAuthStatusChanged(authStatus));

  void _onAuthStatusChanged(
    AppAuthStatusChanged event,
    Emitter<AppState> emit,
  ) {
    switch (event.authStatus) {
      case AuthStatus.authenticated:
        emit(const AppState.authenticated());
        break;
      case AuthStatus.unauthenticated:
        emit(const AppState.unauthenticated());
        break;
    }
  }

  void _onSignOutRequested(AppSignOutRequested event, Emitter<AppState> emit) {
    unawaited(_userRepository.signOut());
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}
