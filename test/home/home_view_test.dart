// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late AppBloc _appBloc;

  const homeViewAppLogosKey = Key('homeView_appLogos');
  const homeViewTitleAndSubtitleKey = Key('homeView_titleAndSubtitle');
  const homeViewSignOutButtonKey = Key('homeView_signOutButton');

  setUp(() {
    _appBloc = _MockAppBloc();
    when(() => _appBloc.state)
        .thenAnswer((invocation) => AppState.authenticated());
  });

  group('renders', () {
    testWidgets(' correctly', (tester) async {
      await tester.pumpApp(
        HomeView(),
        appBloc: _appBloc,
      );
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('AppLogos', (tester) async {
      await tester.pumpApp(
        HomeView(),
        appBloc: _appBloc,
      );
      expect(find.byKey(homeViewAppLogosKey), findsOneWidget);
    });

    testWidgets('TitleAndSubtitle', (WidgetTester tester) async {
      await tester.pumpApp(
        HomeView(),
        appBloc: _appBloc,
      );
      expect(find.byKey(homeViewTitleAndSubtitleKey), findsOneWidget);
    });

    testWidgets('SignOutButton', (tester) async {
      await tester.pumpApp(
        HomeView(),
        appBloc: _appBloc,
      );
      expect(find.byKey(homeViewSignOutButtonKey), findsOneWidget);
    });
  });

  group('adds', () {
    testWidgets('AppSignOutRequested when SignOutButton is tapped',
        (tester) async {
      await tester.pumpApp(
        HomeView(),
        appBloc: _appBloc,
      );
      await tester.tap(find.byKey(homeViewSignOutButtonKey));
      verify(() => _appBloc.add(AppSignOutRequested())).called(1);
    });
  });
}
