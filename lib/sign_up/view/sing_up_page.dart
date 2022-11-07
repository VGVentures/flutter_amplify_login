import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SignUpPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignUpBloc(userRepository: context.read<UserRepository>()),
      child: const SignUpView(),
    );
  }
}
