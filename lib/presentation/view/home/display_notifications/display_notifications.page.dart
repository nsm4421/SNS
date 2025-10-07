import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'display_notifications.screen.dart';

@RoutePage()
class DisplayNotificationsPage extends StatelessWidget {
  const DisplayNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DisplayNotificationsScreen();
  }
}
