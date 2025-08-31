import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sns/presentation/router/app_router.dart';

@RoutePage()
class DisplayFeedPage extends StatelessWidget {
  const DisplayFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Feed"),
        actions: [
          IconButton(
            onPressed: () async {
              await context.pushRoute(const CreateFeedRoute());
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
