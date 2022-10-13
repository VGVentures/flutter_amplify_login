part of 'app_bloc.dart';

enum AppStatus {
  onboardingRequired,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = AmplifyUser.anonymous,
  });

  const AppState.authenticated(AmplifyUser user)
      : this(
          status: AppStatus.authenticated,
          user: user,
        );

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  final AppStatus status;
  final AmplifyUser user;

  @override
  List<Object?> get props => [
        status,
        user,
      ];

  AppState copyWith({
    AppStatus? status,
    AmplifyUser? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
