import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
import 'package:flutter_amplify_login/sign_in/view/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';

class ConfirmationCodeForm extends StatelessWidget {
  const ConfirmationCodeForm({
    super.key,
    required this.email,
  });

  final String email;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConfirmationCodeBloc>().state;
    final theme = Theme.of(context).textTheme;

    return BlocListener<ConfirmationCodeBloc, ConfirmationCodeState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please sign in!'),
            ),
          );
          Navigator.of(context).push<void>(
            SignInPage.route(),
          );
        }
      },
      child: Padding(
        key: const Key('confirmationCodeForm_confirmationCodeModal'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxlg),
            Text(
              'Add the confirmation code \nreceived on $email',
              style: theme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xxlg),
            const _ConfirmationCodeTextFieldSignUp(),
            const SizedBox(height: AppSpacing.xxlg),
            AppButton(
              key: const Key('signUp_signUpButton'),
              onPressed: state.isValid
                  ? () => context.read<ConfirmationCodeBloc>().add(
                        ConfirmationCodeSubmitted(
                          email,
                          state.confirmationCode.value,
                        ),
                      )
                  : null,
              child: const Text('Confirm account'),
            ),
            const SizedBox(height: AppSpacing.xxlg),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationCodeTextFieldSignUp extends StatelessWidget {
  const _ConfirmationCodeTextFieldSignUp();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConfirmationCodeBloc>().state;

    return AppTextField(
      key: const Key('confirmationCode_codeTextField'),
      hintText: 'Confirmation code',
      keyboardType: TextInputType.number,
      prefix: const Icon(Icons.numbers),
      errorText: state.status.isFailure ? 'Invalid code' : null,
      onChanged: (code) => context.read<ConfirmationCodeBloc>().add(
            ConfirmationCodeChanged(code),
          ),
    );
  }
}
