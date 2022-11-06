part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppSignOutRequested extends AppEvent {
  const AppSignOutRequested();
}

class AppAuthStatusChanged extends AppEvent {
  const AppAuthStatusChanged(this.authStatus);

  final AuthStatus authStatus;

  @override
  List<Object> get props => [authStatus];
}
