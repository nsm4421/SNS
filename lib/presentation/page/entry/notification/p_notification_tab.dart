import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 's_notification_tab.dart';

@RoutePage()
class NotificationTabPage extends StatelessWidget {
  const NotificationTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _NotificationTabScreen();
  }
}
