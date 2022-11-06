part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated, sessionExpired }

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.unauthenticated,
  });

  const AppState.authenticated() : this(status: AppStatus.authenticated);

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  const AppState.sessionExpired() : this(status: AppStatus.sessionExpired);

  final AppStatus status;

  @override
  List<Object?> get props => [status];

  AppState copyWith({
    AppStatus? status,
  }) {
    return AppState(
      status: status ?? this.status,
    );
  }
}
