import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'group_tab.screen.dart';

@RoutePage()
class GroupTabPage extends StatelessWidget {
  const GroupTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GroupTabScreen();
  }
}
