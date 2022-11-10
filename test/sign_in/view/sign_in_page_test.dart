// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/sign_in/sign_in.dart';
import 'package:flutter_amplify_login/sign_in/view/sign_in_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

void main() {
  late SignInBloc _signInBloc;

  setUp(() {
    _signInBloc = _MockSignInBloc();
    when(() => _signInBloc.state).thenAnswer((invocation) => SignInState());
  });
  group('SignInPage', () {
    test('has a page', () {
      expect(SignInPage.page(), isA<MaterialPage<void>>());
    });

    testWidgets('renders SignInView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInPage(),
        ),
      );
      expect(find.byType(SignInView), findsOneWidget);
    });
  });
}
