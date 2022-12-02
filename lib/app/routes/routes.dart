import 'package:flutter/widgets.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/home/home.dart';
import 'package:flutter_amplify_login/sign_in/sign_in.dart';

List<Page<void>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
      return [SignInPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
