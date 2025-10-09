import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'setting_tab.screen.dart';

@RoutePage()
class SettingTabPage extends StatelessWidget {
  const SettingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingTabScreen();
  }
}
