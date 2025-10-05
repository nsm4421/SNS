import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'display_chats.screen.dart';

@RoutePage()
class DisplayChatsPage extends StatelessWidget {
  const DisplayChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DisplayChatsScreen();
  }
}
