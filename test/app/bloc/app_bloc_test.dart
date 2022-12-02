// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('AppBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();

      when(() => userRepository.authStatus).thenAnswer((_) => Stream.empty());
    });

    test('initial state is unauthenticated when user is not authenticated', () {
      expect(
        AppBloc(userRepository: userRepository, isAuthenticated: false).state,
        AppState.unauthenticated(),
      );
    });

    group('AppAuthStatusChanged', () {
      blocTest<AppBloc, AppState>(
        'emits nothing when '
        'state is unauthenticated and isAuthenticated is false',
        setUp: () {
          when(() => userRepository.authStatus).thenAnswer(
            (_) => Stream.value(AuthStatus.unauthenticated),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          isAuthenticated: false,
        ),
        seed: AppState.unauthenticated,
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated when isAuthenticated',
        setUp: () {
          when(() => userRepository.authStatus).thenAnswer(
            (_) => Stream.value(AuthStatus.authenticated),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          isAuthenticated: true,
        ),
        expect: () => [AppState.authenticated()],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when the status is unauthenticated',
        setUp: () {
          when(() => userRepository.authStatus).thenAnswer(
            (_) => Stream.value(AuthStatus.unauthenticated),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          isAuthenticated: true,
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
          isAuthenticated: true,
        ),
        act: (bloc) => bloc.add(AppSignOutRequested()),
        verify: (_) {
          verify(() => userRepository.signOut()).called(1);
        },
      );
    });

    group('close', () {
      late StreamController<AuthStatus> authStatusController;

      setUp(() {
        authStatusController = StreamController<AuthStatus>();

        when(() => userRepository.authStatus)
            .thenAnswer((_) => authStatusController.stream);
      });

      blocTest<AppBloc, AppState>(
        'cancels UserRepository.authStatus subscription',
        build: () => AppBloc(
          userRepository: userRepository,
          isAuthenticated: true,
        ),
        tearDown: () => expect(authStatusController.hasListener, isFalse),
      );
    });
  });
}
