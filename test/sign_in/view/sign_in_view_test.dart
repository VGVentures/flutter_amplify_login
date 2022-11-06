// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/sign_in/sign_in.dart';
import 'package:flutter_amplify_login/sign_in/view/sign_in_view.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

void main() {
  late SignInBloc _signInBloc;

  const testEmail = 'test@gmail.com';
  const invalidTestEmail = 'test@g';
  const testPassword = 'Password1';
  const invalidTestPassword = 'password';

  const signInViewAWSLogoKey = Key('signIn_awsLogo');
  const signInViewTitleKey = Key('signIn_title');
  const signInViewSubtitleKey = Key('signIn_subtitle');
  const signInViewEmailTextFieldKey = Key('signIn_emailTextField');
  const signInViewPasswordTextFieldKey = Key('signIn_passwordTextField');
  const signInNotAccountButtonKey = Key('singIn_notAccountButton');
  const signInSignInButtonKey = Key('signIn_signInButton');

  setUp(() {
    _signInBloc = _MockSignInBloc();
    when(() => _signInBloc.state).thenAnswer((invocation) => SignInState());
  });

  group('renders', () {
    testWidgets('AWS Logo', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      expect(find.byKey(signInViewAWSLogoKey), findsOneWidget);
    });

    testWidgets('signIn title', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      expect(find.byKey(signInViewTitleKey), findsOneWidget);
    });

    testWidgets('signIn subtitle', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );

      expect(find.byKey(signInViewSubtitleKey), findsOneWidget);
    });

    testWidgets('email textField', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );

      final emailTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.key == signInViewEmailTextFieldKey,
      );
      expect(emailTextField, findsOneWidget);
    });

    testWidgets('password textField', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      final passwordTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signInViewPasswordTextFieldKey,
      );
      expect(passwordTextField, findsOneWidget);
    });

    testWidgets('sign in button', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      expect(find.byKey(signInSignInButtonKey), findsOneWidget);
    });

    testWidgets('not account widget', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      expect(find.byKey(signInNotAccountButtonKey), findsOneWidget);
    });

    testWidgets('disable sign in button when status is not validated',
        (tester) async {
      when(() => _signInBloc.state).thenReturn(
        const SignInState(),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      final signUpButton = tester.widget<AppButton>(
        find.byKey(signInSignInButtonKey),
      );
      expect(signUpButton.onPressed, null);
    });

    testWidgets('disable sign in button when invalid email is added',
        (tester) async {
      when(() => _signInBloc.state).thenReturn(
        const SignInState(),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      final emailTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.key == signInViewEmailTextFieldKey,
      );
      await tester.enterText(emailTextField, invalidTestEmail);

      final signUpButton = tester.widget<AppButton>(
        find.byKey(signInSignInButtonKey),
      );
      expect(signUpButton.onPressed, null);
    });

    testWidgets('disable sign in button when invalid password is added',
        (tester) async {
      when(() => _signInBloc.state).thenReturn(
        const SignInState(),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      final passwordTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signInViewPasswordTextFieldKey,
      );
      await tester.enterText(passwordTextField, invalidTestPassword);

      final signUpButton = tester.widget<AppButton>(
        find.byKey(signInSignInButtonKey),
      );
      expect(signUpButton.onPressed, null);
    });

    testWidgets('failure SnackBar when submission fails', (tester) async {
      whenListen(
        _signInBloc,
        Stream.fromIterable(const <SignInState>[
          SignInState(status: SignInStatus.loading),
          SignInState(status: SignInStatus.failure),
        ]),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
  group('adds', () {
    testWidgets('SignInEmailChanged when email changes', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );

      final emailTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.key == signInViewEmailTextFieldKey,
      );
      await tester.enterText(emailTextField, testEmail);

      verify(() => _signInBloc.add(const SignInEmailChanged(testEmail)))
          .called(1);
    });

    testWidgets('SignInPasswordChanged when password changes', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );

      final passwordTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signInViewPasswordTextFieldKey,
      );

      await tester.enterText(passwordTextField, testPassword);

      verify(() => _signInBloc.add(const SignInPasswordChanged(testPassword)))
          .called(1);
    });

    testWidgets('SignInSubmitted when sign in button is pressed',
        (tester) async {
      when(() => _signInBloc.state).thenReturn(
        SignInState(
          isValid: true,
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      verify(
        () => _signInBloc.add(
          const SignInSubmitted(
            testEmail,
            testPassword,
          ),
        ),
      ).called(1);
    });
  });

  group('navigates', () {
    testWidgets('to SignUpPage when Sign Up richText is pressed',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signInBloc,
          child: SignInView(),
        ),
      );
      final richText = tester.widget<RichText>(
        find.byKey(signInNotAccountButtonKey),
      );

      tapTextSpan(richText, 'Sign Up!');
      await tester.pumpAndSettle();
      expect(find.byType(SignUpPage), findsOneWidget);
    });
  });
}

void tapTextSpan(RichText richText, String text) =>
    richText.text.visitChildren((visitor) {
      if (visitor is TextSpan && visitor.text == text) {
        final recognizer = visitor.recognizer;
        if (recognizer is TapGestureRecognizer) {
          recognizer.onTap!();
        }
        return false;
      }
      return true;
    });
