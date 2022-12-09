import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/generated/generated.dart';
import 'package:flutter_amplify_login/sign_in/sign_in.dart';
import 'package:flutter_amplify_login/sign_up/view/sign_up_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.status == SignInStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong. Try it later or sign up.'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
          ),
          child: ScrollableColumn(
            children: [
              SizedBox(height: AppSpacing.xxlg),
              _AWSLogo(),
              SizedBox(height: AppSpacing.xxlg),
              _TitleAndSubtitleSignIn(),
              SizedBox(height: AppSpacing.xxlg),
              _EmailTextFieldSignIn(),
              SizedBox(height: AppSpacing.lg),
              _PasswordFieldSignIn(),
              SizedBox(height: AppSpacing.lg),
              _SignInButton(),
              Spacer(),
              _NotAccountSignIn(),
              SizedBox(height: AppSpacing.xxlg),
            ],
          ),
        ),
      ),
    );
  }
}

class _AWSLogo extends StatelessWidget {
  const _AWSLogo();

  @override
  Widget build(BuildContext context) {
    return Assets.images.awsLogo.image(
      key: const Key('signIn_awsLogo'),
      width: 200,
    );
  }
}

class _TitleAndSubtitleSignIn extends StatelessWidget {
  const _TitleAndSubtitleSignIn();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          key: const Key('signIn_title'),
          'Very Good Amplify Login',
          style: theme.headline5,
          textAlign: TextAlign.center,
        ),
        Text(
          key: const Key('signIn_subtitle'),
          'By Very Good Ventures',
          style: theme.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EmailTextFieldSignIn extends StatelessWidget {
  const _EmailTextFieldSignIn();

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      key: const Key('signIn_emailTextField'),
      hintText: 'Email',
      autoFillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      prefix: const Icon(Icons.email),
      onChanged: (email) => context.read<SignInBloc>().add(
            SignInEmailChanged(email),
          ),
    );
  }
}

class _PasswordFieldSignIn extends StatelessWidget {
  const _PasswordFieldSignIn();

  @override
  Widget build(BuildContext context) {
    final isObscure = context.select((SignInBloc bloc) => bloc.state.isObscure);

    return AppTextField(
      key: const Key('signIn_passwordTextField'),
      hintText: 'Password',
      autoFillHints: const [AutofillHints.password],
      obscureText: isObscure,
      prefix: const Icon(Icons.lock),
      suffix: IconButton(
        icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
        onPressed: () => context.read<SignInBloc>().add(
              const SignInPasswordVisibilityToggled(),
            ),
      ),
      onChanged: (password) => context.read<SignInBloc>().add(
            SignInPasswordChanged(password),
          ),
    );
  }
}

class _NotAccountSignIn extends StatelessWidget {
  const _NotAccountSignIn();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RichText(
        key: const Key('signIn_notAccountButton'),
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: "Don't have an account? ",
              style: theme.textTheme.bodyText1,
            ),
            TextSpan(
              text: 'Sign Up!',
              style: theme.textTheme.bodyText1?.apply(
                color: AppColors.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).push<void>(
                      SignUpPage.route(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignInBloc>().state;

    return AppButton(
      key: const Key('signIn_signInButton'),
      onPressed: state.isValid
          ? () => context.read<SignInBloc>().add(
                SignInSubmitted(
                  state.email.value,
                  state.password.value,
                ),
              )
          : null,
      child: state.status == SignInStatus.loading
          ? const CircularProgressIndicator()
          : const Text('Sign In'),
    );
  }
}
