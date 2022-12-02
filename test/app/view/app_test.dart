// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/home/view/home_page.dart';
import 'package:flutter_amplify_login/sign_in/view/sign_in_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late UserRepository userRepository;
  late AppBloc appBloc;

  setUp(() {
    userRepository = _MockUserRepository();
    when(() => userRepository.authStatus)
        .thenAnswer((_) => const Stream.empty());
    appBloc = _MockAppBloc();
  });

  group('App', () {
    testWidgets('renders App', (tester) async {
      await tester.pumpApp(
        App(
          userRepository: userRepository,
          isAuthenticated: true,
        ),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      expect(find.byType(App), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      when(() => appBloc.state).thenReturn(AppState.authenticated());
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('navigates to SignInPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(AppState.unauthenticated());
      await tester.pumpApp(
        const AppView(),
        appBloc: appBloc,
        userRepository: userRepository,
      );
      await tester.pumpAndSettle();
      expect(find.byType(SignInPage), findsOneWidget);
    });
  });
}
