import 'package:flutter/widgets.dart';
import 'package:flutter_amplify_login/app/app.dart';
import 'package:flutter_amplify_login/home/view/home_page.dart';
import 'package:flutter_amplify_login/sign_in/view/sign_in_page.dart';

List<Page<void>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.unauthenticated:
      return [SignInPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.sessionExpired:
      return [SignInPage.page()];
  }
}
