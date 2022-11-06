import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/sign_in/view/sign_in_view.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SignInPage());

  @override
  Widget build(BuildContext context) {
    return const SignInView();
  }
}
