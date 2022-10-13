// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _MockUser extends Mock implements AmplifyUser {}

void main() {
  group('AppBloc', () {
    final user = _MockUser();
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();

      when(() => userRepository.user).thenAnswer((_) => Stream.empty());
    });

    test('initial state is unauthenticated when user is anonymous', () {
      expect(
        AppBloc(
          userRepository: userRepository,
          user: AmplifyUser.anonymous,
        ).state,
        AppState.unauthenticated(),
      );
    });

    group('AppUserChanged', () {
      late AmplifyUser returningUser;
      late AmplifyUser newUser;

      setUp(() {
        returningUser = _MockUser();
        newUser = _MockUser();
        when(() => returningUser.id).thenReturn('id');
        when(() => newUser.id).thenReturn('id');
      });

      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(AmplifyUser.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when user is returning and not anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(returningUser),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.authenticated(returningUser)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is anonymous',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
            (_) => Stream.value(AmplifyUser.anonymous),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('AppSignOutRequested', () {
      setUp(() {
        when(() => userRepository.signOut()).thenAnswer((_) async {});
      });

      blocTest<AppBloc, AppState>(
        'calls logOut on UserRepository',
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.add(AppSignOutRequested()),
        verify: (_) {
          verify(() => userRepository.signOut()).called(1);
        },
      );
    });

    group('close', () {
      late StreamController<AmplifyUser> userController;

      setUp(() {
        userController = StreamController<AmplifyUser>();

        when(() => userRepository.user)
            .thenAnswer((_) => userController.stream);
      });

      blocTest<AppBloc, AppState>(
        'cancels UserRepository.user subscription',
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        tearDown: () => expect(userController.hasListener, isFalse),
      );
    });
  });
}
