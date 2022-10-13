// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:auth_client/auth_client.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUser extends Mock implements AmplifyUser {}

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, AmplifyUser.anonymous);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final user = _MockUser();
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          AppState.unauthenticated().copyWith(),
          equals(AppState.unauthenticated()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          AppState.unauthenticated().copyWith(
            status: AppStatus.onboardingRequired,
          ),
          equals(
            AppState(
              status: AppStatus.onboardingRequired,
            ),
          ),
        );
      });

      test(
          'returns object with updated user '
          'when user is passed', () {
        final user = _MockUser();
        expect(
          AppState.unauthenticated().copyWith(
            user: user,
          ),
          equals(
            AppState(
              status: AppStatus.unauthenticated,
              user: user,
            ),
          ),
        );
      });
    });
  });
}
