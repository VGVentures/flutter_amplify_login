// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

void main() {
  late SignUpBloc _signUpBloc;

  const testEmail = 'test@gmail.com';
  const invalidTestEmail = 'test@g';
  const testPassword = 'Password1';
  const invalidTestPassword = 'password';

  const signUpViewAWSLogoKey = Key('signUp_awsLogo');
  const signUpViewVGVLogoKey = Key('signUp_vgvLogo');
  const signUpViewTitleKey = Key('signUp_title');
  const signUpViewEmailTextFieldKey = Key('signUp_emailTextField');
  const signUpViewPasswordTextFieldKey = Key('signUp_passwordTextField');
  const signUpSignUpButtonKey = Key('signUp_signUpButton');

  setUp(() {
    _signUpBloc = _MockSignUpBloc();
    when(() => _signUpBloc.state).thenAnswer((invocation) => SignUpState());
  });

  group('renders', () {
    testWidgets('AWS Logo', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      expect(find.byKey(signUpViewAWSLogoKey), findsOneWidget);
    });

    testWidgets('VGV Logo', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      expect(find.byKey(signUpViewVGVLogoKey), findsOneWidget);
    });

    testWidgets('signUp title', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      expect(find.byKey(signUpViewTitleKey), findsOneWidget);
    });

    testWidgets('email textField', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );

      final emailTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.key == signUpViewEmailTextFieldKey,
      );
      expect(emailTextField, findsOneWidget);
    });

    testWidgets('password textField', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );

      final passwordTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signUpViewPasswordTextFieldKey,
      );
      expect(passwordTextField, findsOneWidget);
    });

    testWidgets('signUp button', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      expect(find.byKey(signUpSignUpButtonKey), findsOneWidget);
    });

    testWidgets('disable sign up button when status is not validated',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final signUpButton = tester.widget<AppButton>(
        find.byKey(signUpSignUpButtonKey),
      );
      expect(signUpButton.onPressed, null);
    });

    testWidgets('disable sign up button when invalid email is added',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final emailTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.key == signUpViewEmailTextFieldKey,
      );
      await tester.enterText(emailTextField, invalidTestEmail);

      final signUpButton = tester.widget<AppButton>(
        find.byKey(signUpSignUpButtonKey),
      );
      expect(signUpButton.onPressed, null);
    });

    testWidgets('disable sign up button when invalid password is added',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final passwordTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signUpViewPasswordTextFieldKey,
      );
      await tester.enterText(passwordTextField, invalidTestPassword);

      final signUpButton = tester.widget<AppButton>(
        find.byKey(signUpSignUpButtonKey),
      );
      expect(signUpButton.onPressed, null);
    });

    testWidgets('failure SnackBar when submission fails', (tester) async {
      whenListen(
        _signUpBloc,
        Stream.fromIterable(const <SignUpState>[
          SignUpState(status: SignUpStatus.loading),
          SignUpState(status: SignUpStatus.failure),
        ]),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('failure ConfirmationCodePage when submission succeeds',
        (tester) async {
      whenListen(
        _signUpBloc,
        Stream.fromIterable(const <SignUpState>[
          SignUpState(status: SignUpStatus.loading),
          SignUpState(status: SignUpStatus.success),
        ]),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationCodePage), findsOneWidget);
    });

    testWidgets(
        'show CircularProgressIndicator in signUp button '
        'when state is loading', (tester) async {
      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(status: SignUpStatus.loading),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final signUpButton = tester.widget<AppButton>(
        find.byKey(signUpSignUpButtonKey),
      );
      expect(signUpButton.child, isA<CircularProgressIndicator>());
    });

    testWidgets('password with obscureText false', (tester) async {
      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(status: SignUpStatus.loading),
      );
      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(isObscure: false),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final passwordTextFieldFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signUpViewPasswordTextFieldKey,
      );

      final passwordTextField =
          tester.widget<AppTextField>(passwordTextFieldFinder);

      expect(passwordTextField.obscureText, false);
    });

    testWidgets('password with obscureText true', (tester) async {
      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(status: SignUpStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final passwordTextFieldFinder = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signUpViewPasswordTextFieldKey,
      );

      final passwordTextField =
          tester.widget<AppTextField>(passwordTextFieldFinder);

      expect(passwordTextField.obscureText, true);
    });
  });

  group('adds', () {
    testWidgets('SignUpEmailChanged when email changes', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );

      final emailTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.key == signUpViewEmailTextFieldKey,
      );
      await tester.enterText(emailTextField, testEmail);

      verify(() => _signUpBloc.add(const SignUpEmailChanged(testEmail)))
          .called(1);
    });

    testWidgets('SignUpPasswordChanged when password changes', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );

      final passwordTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == signUpViewPasswordTextFieldKey,
      );

      await tester.enterText(passwordTextField, testPassword);

      verify(() => _signUpBloc.add(const SignUpPasswordChanged(testPassword)))
          .called(1);
    });

    testWidgets('SignUpSubmitted when sign up button is pressed',
        (tester) async {
      when(() => _signUpBloc.state).thenReturn(
        SignUpState(
          isValid: true,
          email: Email.dirty(testEmail),
          password: Password.dirty(testPassword),
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );

      final button = find.byKey(signUpSignUpButtonKey);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(
        () => _signUpBloc.add(
          SignUpSubmitted(
            testEmail,
            testPassword,
          ),
        ),
      ).called(1);
    });
    testWidgets(
        'SignUpPasswordVisibilityToggled when visibility icon is is pressed',
        (tester) async {
      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(status: SignUpStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final iconVisibility = find.byIcon(Icons.visibility);

      await tester.ensureVisible(iconVisibility);
      await tester.tap(iconVisibility);
      await tester.pump();

      verify(
        () => _signUpBloc.add(SignUpPasswordVisibilityToggled()),
      ).called(1);
    });

    testWidgets(
        'SignUpPasswordVisibilityToggled when visibilityOff icon is is pressed',
        (tester) async {
      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(status: SignUpStatus.loading),
      );

      when(() => _signUpBloc.state).thenReturn(
        const SignUpState(isObscure: false),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
      );
      final iconVisibilityOff = find.byIcon(Icons.visibility_off);

      await tester.ensureVisible(iconVisibilityOff);
      await tester.tap(iconVisibilityOff);
      await tester.pump();

      verify(
        () => _signUpBloc.add(
          SignUpPasswordVisibilityToggled(),
        ),
      ).called(1);
    });
  });

  group('navigates', () {
    testWidgets('when status is SignUpStatus.success', (tester) async {
      final navigator = MockNavigator();

      when(() => navigator.push<void>(any())).thenAnswer((invocation) async {});

      whenListen(
        _signUpBloc,
        Stream.fromIterable(const <SignUpState>[
          SignUpState(status: SignUpStatus.loading),
          SignUpState(status: SignUpStatus.success),
        ]),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: _signUpBloc,
          child: SignUpView(),
        ),
        navigator: navigator,
      );

      await tester.pumpAndSettle();

      verify(navigator.pop).called(1);
    });
  });
}
