import 'package:flutter/material.dart';
import 'submit_button.widget.dart';

import 'form.fragment.dart';

class CreateTopicScreen extends StatelessWidget {
  const CreateTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Topic")),
      body: const CreateTopicFragment(),
      floatingActionButton: const SubmitButtonWidget(),
    );
  }
}
