part of '../display_posts.page.dart';

class PostCommentScreen extends StatelessWidget {
  const PostCommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        // 댓글 개수
                        BlocBuilder<
                          CreateParentPostCommentCubit,
                          SimpleDataState<CreateParentPostCommentData>
                        >(
                          builder: (context, state) {
                            return Text(
                              "댓글 (${state.data.commentsCount})",
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          },
                        ),
                      ],
                    ),

                    // 댓글 목록
                    const DisplayCommentsFragment(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: const SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: false,
          child: SizedBox(
            width: double.infinity,
            child: CommentTextField(), // 네 입력 위젯
          ),
        ),
      ),
    );
  }
}
