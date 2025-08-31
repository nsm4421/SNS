part of 'display_feed.page.dart';

class DisplayFeedScreen extends StatelessWidget {
  const DisplayFeedScreen({super.key});

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
