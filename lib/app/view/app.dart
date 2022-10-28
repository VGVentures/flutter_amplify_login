// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/app/routes/routes.dart';
import 'package:flutter_amplify_login/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required UserRepository userRepository,
    required bool isAuthenticated,
  })  : _userRepository = userRepository,
        _isAuthenticated = isAuthenticated;

  final UserRepository _userRepository;
  final bool _isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
        create: (context) => AppBloc(
          userRepository: _userRepository,
          isAuthenticated: _isAuthenticated,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
