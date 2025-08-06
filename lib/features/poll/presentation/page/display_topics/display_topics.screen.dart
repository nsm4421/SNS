import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sns/core/constant/app_routes.constant.dart';

import 'topics_list.fragment.dart';

class DisplayTopicScreen extends StatelessWidget {
  const DisplayTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Topics'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.createTopic.path);
            },
            icon: const Icon(Icons.create_outlined),
            tooltip: 'CREATE',
          ),
        ],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: TopicsListFragment())],
      ),
    );
  }
}
