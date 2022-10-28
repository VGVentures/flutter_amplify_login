import 'package:flutter/material.dart';
import 'package:flutter_amplify_login/home/view/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
