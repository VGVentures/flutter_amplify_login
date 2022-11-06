// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final state = AppState.authenticated();
        expect(state.status, AppStatus.authenticated);
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
            status: AppStatus.unauthenticated,
          ),
          equals(
            AppState(),
          ),
        );
      });

      test(
          'returns object with updated user '
          'when user is passed', () {
        expect(
          AppState.unauthenticated().copyWith(),
          equals(
            AppState(),
          ),
        );
      });
    });
  });
}
