import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home.screen.dart';

class HomePage extends StatelessWidget {
  const HomePage(this._shell, {super.key});

  final StatefulNavigationShell _shell;

  @override
  Widget build(BuildContext context) {
    return HomeScreen(_shell);
  }
}
