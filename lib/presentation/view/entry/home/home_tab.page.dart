import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'home_tab.screen.dart';

@RoutePage()
class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeTabScreen();
  }
}
