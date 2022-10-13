part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppSignOutRequested extends AppEvent {
  const AppSignOutRequested();
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final AmplifyUser user;

  @override
  List<Object> get props => [user];
}
