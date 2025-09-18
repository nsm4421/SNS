import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 'index.screen.dart';

@RoutePage()
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const IndexScreen();
  }
}
