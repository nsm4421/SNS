import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'notification.screen.dart';

@RoutePage()
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationScreen();
  }
}
