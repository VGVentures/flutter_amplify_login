// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  const invalidPasswordString = 'invalid';
  const invalidPassword = Password.dirty(invalidPasswordString);

  const validPasswordString = 'testPassword1';
  const validPassword = Password.dirty(validPasswordString);

  group('SignUpBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();

      when(
        () => userRepository.signUp(
          email: any(named: 'email'),
          password: any(
            named: 'password',
          ),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is SignUpState', () {
      expect(SignUpBloc(userRepository: userRepository).state, SignUpState());
    });

    group('EmailChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when email is invalid and password is invalid',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(invalidEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: invalidEmail,
            password: invalidPassword,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when email is invalid and password is valid',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(invalidEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: invalidEmail,
            password: validPassword,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [valid] when email is valid and password is valid',
        build: () => SignUpBloc(userRepository: userRepository),
        seed: () => SignUpState(password: validPassword),
        act: (bloc) => bloc.add(SignUpEmailChanged(validEmailString)),
        expect: () => <SignUpState>[
          SignUpState(
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );
    });

    group('PasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when password is invalid and email is invalid',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(invalidEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: invalidEmail,
            password: invalidPassword,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [invalid] when password is invalid and email is valid',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpEmailChanged(invalidEmailString)),
        expect: () => const <SignUpState>[
          SignUpState(
            email: invalidEmail,
            password: validPassword,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [valid] when password is valid and email is valid',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpPasswordChanged(validPasswordString)),
        seed: () => SignUpState(email: validEmail),
        expect: () => <SignUpState>[
          SignUpState(
            password: validPassword,
            email: validEmail,
            valid: true,
          ),
        ],
      );
    });

    group('SignUpSubmitted', () {
      blocTest<SignUpBloc, SignUpState>(
        'does nothing when status is not validated',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          SignUpSubmitted(
            validEmailString,
            invalidPasswordString,
          ),
        ),
        expect: () => const <SignUpState>[],
      );

      blocTest<SignUpBloc, SignUpState>(
        'calls signUp with correct email and password',
        build: () => SignUpBloc(userRepository: userRepository),
        seed: () => SignUpState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(
          SignUpSubmitted(
            validEmailString,
            validPasswordString,
          ),
        ),
        verify: (_) {
          verify(
            () => userRepository.signUp(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when signUp succeeds',
        build: () => SignUpBloc(userRepository: userRepository),
        seed: () => SignUpState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(
          SignUpSubmitted(
            validEmailString,
            validPasswordString,
          ),
        ),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            valid: true,
          ),
          SignUpState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            valid: true,
          )
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [submissionInProgress, submissionFailure] '
        'when signUp fails',
        setUp: () {
          when(
            () => userRepository.signUp(
              email: any(named: 'email'),
              password: any(
                named: 'password',
              ),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => SignUpBloc(userRepository: userRepository),
        seed: () => SignUpState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(
          SignUpSubmitted(
            validEmailString,
            validPasswordString,
          ),
        ),
        expect: () => const <SignUpState>[
          SignUpState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            valid: true,
          ),
          SignUpState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            valid: true,
          )
        ],
      );
    });
  });
}
