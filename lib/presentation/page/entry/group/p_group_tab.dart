import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 's_group_tab.dart';

@RoutePage()
class GroupTabPage extends StatelessWidget {
  const GroupTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GroupTabScreen();
  }
}
