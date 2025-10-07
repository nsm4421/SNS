import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'display_profiles.screen.dart';

@RoutePage()
class DisplayProfilesPage extends StatelessWidget {
  const DisplayProfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DisplayProfilesScreen();
  }
}
