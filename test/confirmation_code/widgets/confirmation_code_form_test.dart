// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../helpers/helpers.dart';

class _MockConfirmationCodeBloc
    extends MockBloc<ConfirmationCodeEvent, ConfirmationCodeState>
    implements ConfirmationCodeBloc {}

void main() {
  late ConfirmationCodeBloc _confirmationCodeBloc;
  const testEmail = 'test@gmail.com';
  const testValidCode = '123456';

  const confirmationCodeFormTitleKey = Key('confirmationCodeForm_title');
  const confirmationCodeFormCodeTextFieldKey =
      Key('confirmationCode_codeTextField');
  const confirmationCodeFormButtonKey =
      Key('confirmationCodeForm_confirmationCodeButton');

  setUp(() {
    _confirmationCodeBloc = _MockConfirmationCodeBloc();
    when(() => _confirmationCodeBloc.state).thenReturn(
      ConfirmationCodeState(),
    );
  });

  group('renders', () {
    testWidgets('ConfirmationCodeForm title', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(confirmationCodeFormTitleKey), findsOneWidget);
    });

    testWidgets('ConfirmationCodeForm code textField', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();
      final codeTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == confirmationCodeFormCodeTextFieldKey,
      );
      expect(codeTextField, findsOneWidget);
    });

    testWidgets(
        'ConfirmationCodeForm code textField with error text '
        'when code number is not valid', (tester) async {
      when(() => _confirmationCodeBloc.state).thenReturn(
        ConfirmationCodeState(
          status: FormzSubmissionStatus.failure,
        ),
      );

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();
      final codeTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == confirmationCodeFormCodeTextFieldKey,
      );

      final confirmationCodeTextField =
          tester.widget<AppTextField>(codeTextField);

      expect(confirmationCodeTextField.errorText, isNotNull);
    });

    testWidgets('ConfirmationCodeForm confirm button', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(confirmationCodeFormButtonKey), findsOneWidget);
    });

    testWidgets('enable confirm code button when status is validated',
        (tester) async {
      when(() => _confirmationCodeBloc.state).thenReturn(
        const ConfirmationCodeState(isValid: true),
      );

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();

      final signUpButton = tester.widget<AppButton>(
        find.byKey(confirmationCodeFormButtonKey),
      );
      expect(signUpButton.onPressed, isNotNull);
    });

    testWidgets('disable confirm code button when status is not validated',
        (tester) async {
      when(() => _confirmationCodeBloc.state).thenReturn(
        const ConfirmationCodeState(),
      );

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();

      final signUpButton = tester.widget<AppButton>(
        find.byKey(confirmationCodeFormButtonKey),
      );
      expect(signUpButton.onPressed, isNull);
    });
  });

  group('adds', () {
    testWidgets('ConfirmationCodeChanged when confirmation code changes',
        (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();
      final codeTextField = find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField &&
            widget.key == confirmationCodeFormCodeTextFieldKey,
      );

      await tester.enterText(codeTextField, testValidCode);

      verify(
        () => _confirmationCodeBloc.add(
          const ConfirmationCodeChanged(testValidCode),
        ),
      ).called(1);
    });

    testWidgets(
        'ConfirmationCodeSubmitted when confirmation code button is pressed',
        (tester) async {
      when(() => _confirmationCodeBloc.state).thenReturn(
        const ConfirmationCodeState(
          isValid: true,
          confirmationCode: ConfirmationCode.dirty(testValidCode),
        ),
      );

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();

      final button = find.byKey(confirmationCodeFormButtonKey);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(
        () => _confirmationCodeBloc.add(
          const ConfirmationCodeSubmitted(
            testEmail,
            testValidCode,
          ),
        ),
      ).called(1);
    });
  });

  group('navigates', () {
    testWidgets('back when status is [FormzSubmissionStatus.success]',
        (tester) async {
      whenListen(
        _confirmationCodeBloc,
        Stream.fromIterable(const <ConfirmationCodeState>[
          ConfirmationCodeState(status: FormzSubmissionStatus.inProgress),
          ConfirmationCodeState(status: FormzSubmissionStatus.success),
        ]),
      );

      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            key: const Key('showModal_button'),
            onPressed: () async => showMaterialModalBottomSheet<void>(
              context: context,
              builder: (context) => BlocProvider.value(
                value: _confirmationCodeBloc,
                child: ConfirmationCodeForm(
                  email: testEmail,
                ),
              ),
            ),
            child: const Text('Tap'),
          ),
        ),
      );
      await tester.tap(find.byKey(Key('showModal_button')));
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationCodeForm), findsNothing);
    });
  });
}
