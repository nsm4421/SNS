import 'package:flutter/material.dart';

import 'topics_list.fragment.dart';

class DisplayTopicScreen extends StatelessWidget {
  const DisplayTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Topics')),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: TopicsListFragment())],
      ),
    );
  }
}
