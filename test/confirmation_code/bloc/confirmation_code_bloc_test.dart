// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_amplify_login/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const validConfirmationCodeString = '123456';
  const validConfirmationCode =
      ConfirmationCode.dirty(validConfirmationCodeString);

  const invalidConfirmationCodeString = '123';
  const invalidConfirmationCode =
      ConfirmationCode.dirty(invalidConfirmationCodeString);

  const emailTest = 'test@gmail.com';

  group('ConfirmationCodeBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();

      when(
        () => userRepository.confirmSignUp(
          email: any(named: 'email'),
          confirmationCode: any(named: 'confirmationCode'),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is ConfirmationCodeState', () {
      expect(
        ConfirmationCodeBloc(userRepository: userRepository).state,
        ConfirmationCodeState(),
      );
    });

    group('ConfirmationCodeSubmitted', () {
      blocTest<ConfirmationCodeBloc, ConfirmationCodeState>(
        'does nothing when status is not validated',
        build: () => ConfirmationCodeBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          ConfirmationCodeSubmitted(
            emailTest,
            invalidConfirmationCodeString,
          ),
        ),
        expect: () => const <SignInState>[],
      );

      blocTest<ConfirmationCodeBloc, ConfirmationCodeState>(
        'calls ConfirmationCodeSubmitted with correct data',
        build: () => ConfirmationCodeBloc(userRepository: userRepository),
        seed: () => ConfirmationCodeState(isValid: true),
        act: (bloc) => bloc.add(
          ConfirmationCodeSubmitted(
            emailTest,
            validConfirmationCodeString,
          ),
        ),
        verify: (_) {
          verify(
            () => userRepository.confirmSignUp(
              email: emailTest,
              confirmationCode: validConfirmationCodeString,
            ),
          ).called(1);
        },
      );
      blocTest<ConfirmationCodeBloc, ConfirmationCodeState>(
        'emits[submissionInProgress, submissionSuccess] '
        ' when confirmSignUp succeeds',
        build: () => ConfirmationCodeBloc(userRepository: userRepository),
        seed: () => ConfirmationCodeState(
          isValid: true,
          confirmationCode: validConfirmationCode,
        ),
        act: (bloc) => bloc.add(
          ConfirmationCodeSubmitted(
            emailTest,
            validConfirmationCodeString,
          ),
        ),
        expect: () => const <ConfirmationCodeState>[
          ConfirmationCodeState(
            status: FormzSubmissionStatus.inProgress,
            confirmationCode: validConfirmationCode,
            isValid: true,
          ),
          ConfirmationCodeState(
            status: FormzSubmissionStatus.success,
            confirmationCode: validConfirmationCode,
            isValid: true,
          )
        ],
      );

      blocTest<ConfirmationCodeBloc, ConfirmationCodeState>(
        'emits [submissionInProgress, submissionFailure] '
        'when confirmSignUp fails',
        setUp: () {
          when(
            () => userRepository.confirmSignUp(
              email: any(named: 'email'),
              confirmationCode: any(
                named: 'confirmationCode',
              ),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => ConfirmationCodeBloc(userRepository: userRepository),
        seed: () => ConfirmationCodeState(
          isValid: true,
          confirmationCode: validConfirmationCode,
        ),
        act: (bloc) => bloc.add(
          ConfirmationCodeSubmitted(
            emailTest,
            validConfirmationCodeString,
          ),
        ),
        expect: () => const <ConfirmationCodeState>[
          ConfirmationCodeState(
            status: FormzSubmissionStatus.inProgress,
            confirmationCode: validConfirmationCode,
            isValid: true,
          ),
          ConfirmationCodeState(
            status: FormzSubmissionStatus.failure,
            confirmationCode: validConfirmationCode,
            isValid: true,
          )
        ],
      );
    });

    group('ConfirmationCodeChanged', () {
      blocTest<ConfirmationCodeBloc, ConfirmationCodeState>(
        'emits [invalid] when confirmation code is invalid',
        build: () => ConfirmationCodeBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          ConfirmationCodeChanged(invalidConfirmationCodeString),
        ),
        expect: () => const <ConfirmationCodeState>[
          ConfirmationCodeState(
            confirmationCode: invalidConfirmationCode,
          ),
        ],
      );

      blocTest<ConfirmationCodeBloc, ConfirmationCodeState>(
        'emits [valid] when confirmation code is valid',
        build: () => ConfirmationCodeBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          ConfirmationCodeChanged(validConfirmationCodeString),
        ),
        expect: () => const <ConfirmationCodeState>[
          ConfirmationCodeState(
            confirmationCode: validConfirmationCode,
            isValid: true,
          ),
        ],
      );
    });
  });
}
