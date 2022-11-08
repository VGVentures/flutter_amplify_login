import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/generated/generated.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
        ),
        child: ScrollableColumn(
          children: [
            SizedBox(height: AppSpacing.xxxlg),
            _AppLogos(),
            SizedBox(height: AppSpacing.xxxlg),
            _TitleAndSubtitle(),
            Spacer(),
            _SignOutButton(),
            SizedBox(height: AppSpacing.xxlg),
          ],
        ),
      ),
    );
  }
}

class _AppLogos extends StatelessWidget {
  const _AppLogos();

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('homeView_appLogos'),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Assets.images.vgvLogo.image(width: 200),
        Assets.images.awsLogo.image(width: 100),
      ],
    );
  }
}

class _TitleAndSubtitle extends StatelessWidget {
  const _TitleAndSubtitle();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      key: const Key('homeView_titleAndSubtitle'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Very Good Amplify Login App',
          style: theme.textTheme.headline4,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Made with 💙 by Very Good Ventures 🦄 and AWS Amplify.',
          style: theme.textTheme.headline6,
        ),
        const SizedBox(height: AppSpacing.xxlg),
        Text(
          'Congratulations, you followed the tutorial and '
          'successfully logged in! Now you can try out the sign-out.',
          style: theme.textTheme.bodyText1,
        ),
      ],
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      key: const Key('homeView_signOutButton'),
      child: const Text('Sign Out'),
      onPressed: () => context.read<AppBloc>().add(const AppSignOutRequested()),
    );
  }
}
