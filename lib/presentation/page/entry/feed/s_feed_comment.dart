part of 'p_feed_tab.dart';

class _FeedCommentScreen extends StatefulWidget {
  const _FeedCommentScreen({super.key});

  @override
  State<_FeedCommentScreen> createState() => _FeedCommentScreenState();
}

class _FeedCommentScreenState extends State<_FeedCommentScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: Text("Comment", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 20,
          itemBuilder: (context, index) {
            return ListTile(
              leading: UserAvatarWidget(context.read<AuthBloc>().currentUser),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "username",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    "1 min ago",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              subtitle: const Text("content"),
            );
          },
          separatorBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(indent: 12, endIndent: 12, thickness: 0.5),
          ),
        ),
      ),
      bottomNavigationBar: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
            tooltip: 'Submit',
          ),
        ),
      ),
    );
  }
}
