part of 'display_posts.page.dart';

class DisplayPostsScreen extends StatelessWidget {
  const DisplayPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Posts"),
        actions: [
          IconButton(
            onPressed: () async {
              await context.pushRoute(const CreatePostRoute());
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body:  BlocBuilder<DisplayPostsBloc, SimpleDisplayState<PostEntity>>(
        builder: (context, state) {
          if (state.data.isEmpty) {
            return const Text('Nothing Fetched');
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return FeedItemWidget(state.data[index]);
            },
            separatorBuilder: (_, __) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Divider(),
              );
            },
          );
        },
      ),
    );
  }
}
