// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

void main() {
  late SignUpBloc _signUpBloc;

  setUp(() {
    _signUpBloc = _MockSignUpBloc();
    when(() => _signUpBloc.state).thenAnswer((invocation) => SignUpState());
  });

  group('SignUpPage', () {
    test('has a route', () {
      expect(SignUpPage.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders SignUpView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpPage(),
        ),
      );
      expect(find.byType(SignUpView), findsOneWidget);
    });
  });
}
