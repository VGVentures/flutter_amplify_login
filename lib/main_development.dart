// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:auth_client/auth_client.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/bootstrap.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(() async {
    final authCategory = Amplify.Auth;

    final authClient = AuthClient(auth: authCategory, hub: Amplify.Hub);
    final userRepository = UserRepository(authClient: authClient);
    final isAuthenticated = await userRepository.isUserAuthenticated();

    return App(
      userRepository: userRepository,
      isAuthenticated: isAuthenticated,
    );
  });
}
