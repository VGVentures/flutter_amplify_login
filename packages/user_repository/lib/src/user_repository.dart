// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auth_client/auth_client.dart';

/// {@template user_repository}
/// A package which manages the user domain
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required AuthClient authClient,
  }) : _authClient = authClient;

  final AuthClient _authClient;
}
