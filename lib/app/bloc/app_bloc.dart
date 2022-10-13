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
    required AmplifyUser user,
  })  : _userRepository = userRepository,
        super(
          user == AmplifyUser.anonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppSignOutRequested>(_onSignOutRequested);

    _userSubscription = _userRepository.user.listen(_userChanged);
  }

  final UserRepository _userRepository;
  late StreamSubscription<AmplifyUser> _userSubscription;

  void _userChanged(AmplifyUser user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user == AmplifyUser.anonymous
            ? emit(const AppState.unauthenticated())
            : emit(
                AppState.authenticated(
                  user,
                ),
              );
    }
  }

  void _onSignOutRequested(AppSignOutRequested event, Emitter<AppState> emit) {
    // We are disabling notifications when a user logs out because
    // the user should not receive any notifications when signed out.

    unawaited(_userRepository.signOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
