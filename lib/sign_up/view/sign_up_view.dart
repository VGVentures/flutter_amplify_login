import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/bloc/confirmation_code_bloc.dart';
import 'package:flutter_amplify_login/confirmation_code/widgets/confirmation_code_form.dart';
import 'package:flutter_amplify_login/generated/generated.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:user_repository/user_repository.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong. Try it later.'),
            ),
          );
        } else if (state.status == SignUpStatus.success) {
          showMaterialModalBottomSheet<void>(
            context: context,
            builder: (context) => BlocProvider(
              create: (_) => ConfirmationCodeBloc(
                userRepository: context.read<UserRepository>(),
              ),
              child: ConfirmationCodeForm(email: state.email.value),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
          ),
          child: ScrollableColumn(
            children: [
              SizedBox(height: AppSpacing.xxxlg),
              _SignUpAWSLogo(),
              SizedBox(height: AppSpacing.xxlg),
              _SignUpTitleAndVGVLogo(),
              SizedBox(height: AppSpacing.xxlg),
              _EmailTextFieldSignUp(),
              _PasswordFieldSignUp(),
              Spacer(),
              _SingUpButton(),
              SizedBox(height: AppSpacing.xxlg),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignUpAWSLogo extends StatelessWidget {
  const _SignUpAWSLogo();

  @override
  Widget build(BuildContext context) {
    return Assets.images.awsLogo.image(
      key: const Key('signUp_awsLogo'),
      width: 200,
    );
  }
}

class _SignUpTitleAndVGVLogo extends StatelessWidget {
  const _SignUpTitleAndVGVLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        Assets.images.vgvLogo.image(
          key: const Key('signUp_vgvLogo'),
          width: 150,
        ),
        const SizedBox(height: AppSpacing.xxlg),
        Text(
          key: const Key('signUp_title'),
          'Fill out the form to Sign Up',
          style: theme.headline5,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EmailTextFieldSignUp extends StatelessWidget {
  const _EmailTextFieldSignUp();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      key: const Key('signUp_emailTextField'),
      hintText: 'Email',
      autoFillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      prefix: const Icon(Icons.email),
      onChanged: (email) => context.read<SignUpBloc>().add(
            SignUpEmailChanged(email),
          ),
    );
  }
}

class _PasswordFieldSignUp extends StatefulWidget {
  const _PasswordFieldSignUp();

  @override
  State<_PasswordFieldSignUp> createState() => _PasswordFieldSignUpState();
}

class _PasswordFieldSignUpState extends State<_PasswordFieldSignUp> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      key: const Key('signUp_passwordTextField'),
      hintText: 'Password',
      autoFillHints: const [AutofillHints.password],
      obscureText: _isObscure,
      prefix: const Icon(Icons.lock),
      suffix: IconButton(
        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
      ),
      onChanged: (password) => context.read<SignUpBloc>().add(
            SignUpPasswordChanged(password),
          ),
    );
  }
}

class _SingUpButton extends StatelessWidget {
  const _SingUpButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;

    return AppButton(
      key: const Key('signUp_signUpButton'),
      onPressed: state.isValid
          ? () => context.read<SignUpBloc>().add(
                SignUpSubmitted(
                  state.email.value,
                  state.password.value,
                ),
              )
          : null,
      child: state.status == SignUpStatus.loading
          ? const CircularProgressIndicator()
          : const Text('Sign Up'),
    );
  }
}
