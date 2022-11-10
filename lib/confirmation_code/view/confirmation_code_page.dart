import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ConfirmationCodePage extends StatelessWidget {
  const ConfirmationCodePage({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmationCodeBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: ConfirmationCodeForm(email: email),
    );
  }
}
