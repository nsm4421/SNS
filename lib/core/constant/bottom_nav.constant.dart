import 'package:flutter/material.dart';

enum BottomNavMenu {
  entry(
    label: 'HOME',
    iconData: Icons.home_outlined,
    activeIconData: Icons.home,
  ),
  setting(
    label: 'SETTING',
    iconData: Icons.settings_outlined,
    activeIconData: Icons.settings,
  );

  final String label;
  final IconData iconData;
  final IconData activeIconData;

  const BottomNavMenu({
    required this.label,
    required this.iconData,
    required this.activeIconData,
  });
}
