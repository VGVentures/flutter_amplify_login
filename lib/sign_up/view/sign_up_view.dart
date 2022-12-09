import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_amplify_login/generated/generated.dart';
import 'package:flutter_amplify_login/sign_up/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (state.status == SignUpStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong. Try it later.'),
            ),
          );
        } else if (state.status == SignUpStatus.success) {
          final navigator = Navigator.of(context);

          await showMaterialModalBottomSheet<void>(
            context: context,
            builder: (context) => ConfirmationCodePage(
              email: state.email.value,
            ),
          );

          // Navigate back when the confirmation code is successful to return to
          // the sign-in page.
          navigator.pop();
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
              _SignUpButton(),
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

class _PasswordFieldSignUp extends StatelessWidget {
  const _PasswordFieldSignUp();

  @override
  Widget build(BuildContext context) {
    final isObscure = context.select((SignUpBloc bloc) => bloc.state.isObscure);

    return AppTextField(
      key: const Key('signUp_passwordTextField'),
      hintText: 'Password',
      autoFillHints: const [AutofillHints.password],
      obscureText: isObscure,
      prefix: const Icon(Icons.lock),
      suffix: IconButton(
        icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
        onPressed: () => context.read<SignUpBloc>().add(
              const SignUpPasswordVisibilityToggled(),
            ),
      ),
      onChanged: (password) => context.read<SignUpBloc>().add(
            SignUpPasswordChanged(password),
          ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

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
