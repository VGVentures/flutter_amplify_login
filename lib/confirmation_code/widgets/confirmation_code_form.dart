import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/confirmation_code/confirmation_code.dart';
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
    return BlocListener<ConfirmationCodeBloc, ConfirmationCodeState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        key: const Key('confirmationCodeForm_confirmationCodeModal'),
        padding: MediaQuery.of(context).viewInsets.copyWith(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxlg),
            _ConfirmationCodeTitle(email: email),
            const SizedBox(height: AppSpacing.xxlg),
            const _ConfirmationCodeTextFieldSignUp(),
            const SizedBox(height: AppSpacing.xxlg),
            _ConfirmationCodeButton(email: email),
            const SizedBox(height: AppSpacing.xxlg),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationCodeTitle extends StatelessWidget {
  const _ConfirmationCodeTitle({
    required this.email,
  });

  final String email;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Text(
      key: const Key('confirmationCodeForm_title'),
      'Add the confirmation code \nreceived on $email',
      style: theme.bodyMedium,
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

class _ConfirmationCodeButton extends StatelessWidget {
  const _ConfirmationCodeButton({
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConfirmationCodeBloc>().state;

    return AppButton(
      key: const Key('confirmationCodeForm_confirmationCodeButton'),
      onPressed: state.isValid
          ? () => context.read<ConfirmationCodeBloc>().add(
                ConfirmationCodeSubmitted(
                  email,
                  state.confirmationCode.value,
                ),
              )
          : null,
      child: const Text('Confirm code'),
    );
  }
}
