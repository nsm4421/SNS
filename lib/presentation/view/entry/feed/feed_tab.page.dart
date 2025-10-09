import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'feed_tab.screen.dart';

@RoutePage()
class FeedTabPage extends StatelessWidget {
  const FeedTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeedTabScreen();
  }
}
