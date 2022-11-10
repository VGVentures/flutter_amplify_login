// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../helpers/helpers.dart';

class _MockConfirmationCodeBloc
    extends MockBloc<ConfirmationCodeEvent, ConfirmationCodeState>
    implements ConfirmationCodeBloc {}

void main() {
  late ConfirmationCodeBloc _confirmationCodeBloc;
  const testEmail = 'test@gmail.com';

  setUp(() {
    _confirmationCodeBloc = _MockConfirmationCodeBloc();
    when(() => _confirmationCodeBloc.state).thenReturn(
      ConfirmationCodeState(),
    );
  });

  group('ConfirmationCodePage', () {
    group('renders', () {
      testWidgets('ConfirmationCodeForm', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) => ElevatedButton(
              key: const Key('showModal_button'),
              onPressed: () => showMaterialModalBottomSheet<void>(
                context: context,
                builder: (context) => BlocProvider.value(
                  value: _confirmationCodeBloc,
                  child: ConfirmationCodePage(
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
        expect(find.byType(ConfirmationCodeForm), findsOneWidget);
      });
    });
  });
}
