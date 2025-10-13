import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 's_chat_tab.dart';

@RoutePage()
class ChatTabPage extends StatelessWidget {
  const ChatTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ChatTabScreen();
  }
}
