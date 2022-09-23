// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:auth_client/auth_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthClient extends Mock implements AuthClient {}

void main() {
  late AuthClient authClient;

  setUp(() {
    authClient = _MockAuthClient();
  });
  group('UserRepository', () {
    test('can be instantiated', () {
      expect(
        UserRepository(
          authClient: authClient,
        ),
        isNotNull,
      );
    });
  });
}
