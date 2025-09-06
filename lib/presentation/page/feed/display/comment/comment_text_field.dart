part of '../display_posts.page.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({super.key});

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  late final TextEditingController _tec;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _tec = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tec.dispose();
  }

  String? _handleValidate(String? text) {
    if (text == null || text.isEmpty) {
      return '댓글을 입력해주세요';
    }
    return null;
  }

  _handleSubmit() async {
    await context.read<CreateParentPostCommentCubit>().submit(_tec.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      CreateParentPostCommentCubit,
      SimpleDataState<CreateParentPostCommentData>
    >(
      listenWhen: (prev, curr) =>
          (curr.status == Status.success) || (curr.status == Status.error),
      listener: (context, state) async {
        if (state.status == Status.success) {
          setState(() {
            _errorText = null;
          });
          // optimistic update
          final currentUser = await context
              .read<AuthenticationBloc>()
              .getCurrentUser();
          context.read<DisplayParentCommentBloc>().add(
            PostCommentCreatedEvent<ParentPostCommentEntity>(
              ParentPostCommentEntity(
                id: state.data.latestCreatedCommentId!,
                content: _tec.text.trim(),
                postId: context.read<CreateParentPostCommentCubit>().postId,
                createdAt: DateTime.now(),
                creator: currentUser,
                children: [],
              ),
            ),
          );
          _tec.clear();
        } else if (state.status == Status.error) {
          setState(() {
            _errorText = state.errorMessage;
          });
        }
      },
      child:
          BlocBuilder<
            CreateParentPostCommentCubit,
            SimpleDataState<CreateParentPostCommentData>
          >(
            builder: (context, state) {
              final tappable = state.status == Status.initial;
              return Form(
                child: TextFormField(
                  validator: _handleValidate,
                  readOnly: !tappable,
                  controller: _tec,
                  decoration: InputDecoration(
                    errorText: _errorText,
                    suffixIcon: IconButton(
                      onPressed: tappable ? _handleSubmit : null,
                      icon: tappable
                          ? const Icon(Icons.send_rounded)
                          : Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
