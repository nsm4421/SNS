import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sns/presentation/router/app_router.dart';

part 'display_feed.screen.dart';

@RoutePage()
class DisplayFeedPage extends StatelessWidget {
  const DisplayFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DisplayFeedScreen();
  }
}
