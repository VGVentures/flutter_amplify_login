// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {
  @override
  AppState get state => const AppState();
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    UserRepository? userRepository,
    AppBloc? appBloc,
    MockNavigator? navigator,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: userRepository ?? MockUserRepository(),
        child: BlocProvider.value(
          value: appBloc ?? MockAppBloc(),
          child: MaterialApp(
            title: 'Flutter Amplify Login',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: navigator == null
                ? Scaffold(body: widgetUnderTest)
                : MockNavigatorProvider(
                    navigator: navigator,
                    child: Scaffold(body: widgetUnderTest),
                  ),
          ),
        ),
      ),
    );
  }
}
