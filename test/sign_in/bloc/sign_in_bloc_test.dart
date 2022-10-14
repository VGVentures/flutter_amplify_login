// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_amplify_login/sign_in/sign_in.dart';
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

  group('SignInBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();

      when(
        () => userRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => Future<void>.value());
    });

    test('initial state is SignInState', () {
      expect(SignInBloc(userRepository: userRepository).state, SignInState());
    });

    group('EmailChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits [invalid] when email is invalid and password is invalid',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInEmailChanged(invalidEmailString)),
        seed: () => SignInState(password: invalidPassword),
        expect: () => const <SignInState>[
          SignInState(
            email: invalidEmail,
            password: invalidPassword,
          ),
        ],
      );

      blocTest<SignInBloc, SignInState>(
        'emits [invalid] when email is invalid and password is valid',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInEmailChanged(invalidEmailString)),
        seed: () => SignInState(password: validPassword),
        expect: () => const <SignInState>[
          SignInState(
            email: invalidEmail,
            password: validPassword,
          ),
        ],
      );

      blocTest<SignInBloc, SignInState>(
        'emits [valid] when email is valid and password is valid',
        build: () => SignInBloc(userRepository: userRepository),
        seed: () => SignInState(password: validPassword),
        act: (bloc) => bloc.add(SignInEmailChanged(validEmailString)),
        expect: () => <SignInState>[
          SignInState(
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
        ],
      );
    });

    group('PasswordChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits [invalid] when password is invalid and email is invalid',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInPasswordChanged(invalidPasswordString)),
        seed: () => SignInState(email: invalidEmail),
        expect: () => const <SignInState>[
          SignInState(
            email: invalidEmail,
            password: invalidPassword,
          ),
        ],
      );

      blocTest<SignInBloc, SignInState>(
        'emits [invalid] when password is invalid and email is valid',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInPasswordChanged(invalidPasswordString)),
        seed: () => SignInState(email: validEmail),
        expect: () => const <SignInState>[
          SignInState(
            email: validEmail,
            password: invalidPassword,
          ),
        ],
      );

      blocTest<SignInBloc, SignInState>(
        'emits [valid] when password is valid and email is valid',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInPasswordChanged(validPasswordString)),
        seed: () => SignInState(email: validEmail),
        expect: () => <SignInState>[
          SignInState(
            password: validPassword,
            email: validEmail,
            valid: true,
          ),
        ],
      );
    });

    group('SignInSubmitted', () {
      blocTest<SignInBloc, SignInState>(
        'does nothing when status is not validated',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          SignInSubmitted(
            validEmailString,
            invalidPasswordString,
          ),
        ),
        expect: () => const <SignInState>[],
      );

      blocTest<SignInBloc, SignInState>(
        'calls signIn with correct email and password',
        build: () => SignInBloc(userRepository: userRepository),
        seed: () => SignInState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(
          SignInSubmitted(
            validEmailString,
            validPasswordString,
          ),
        ),
        verify: (_) {
          verify(
            () => userRepository.signIn(
              email: validEmailString,
              password: validPasswordString,
            ),
          ).called(1);
        },
      );

      blocTest<SignInBloc, SignInState>(
        'emits [submissionInProgress, submissionSuccess] '
        'when signIn succeeds',
        build: () => SignInBloc(userRepository: userRepository),
        seed: () => SignInState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(
          SignInSubmitted(
            validEmailString,
            validPasswordString,
          ),
        ),
        expect: () => const <SignInState>[
          SignInState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
          SignInState(
            status: FormzSubmissionStatus.success,
            email: validEmail,
            password: validPassword,
            valid: true,
          )
        ],
      );

      blocTest<SignInBloc, SignInState>(
        'emits [submissionInProgress, submissionFailure] '
        'when signIn fails',
        setUp: () {
          when(
            () => userRepository.signIn(
              email: any(named: 'email'),
              password: any(
                named: 'password',
              ),
            ),
          ).thenThrow(Exception('oops'));
        },
        build: () => SignInBloc(userRepository: userRepository),
        seed: () => SignInState(
          email: validEmail,
          password: validPassword,
          valid: true,
        ),
        act: (bloc) => bloc.add(
          SignInSubmitted(
            validEmailString,
            validPasswordString,
          ),
        ),
        expect: () => const <SignInState>[
          SignInState(
            status: FormzSubmissionStatus.inProgress,
            email: validEmail,
            password: validPassword,
            valid: true,
          ),
          SignInState(
            status: FormzSubmissionStatus.failure,
            email: validEmail,
            password: validPassword,
            valid: true,
          )
        ],
      );
    });
  });
}
