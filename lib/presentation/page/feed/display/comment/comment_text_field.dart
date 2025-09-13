part of '../display_posts.page.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({super.key});

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  late final TextEditingController _tec;
  late final GlobalKey<FormState> _formKey;
  late final FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _tec = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _focusNode = FocusNode()..addListener(_handleFocus);
  }

  @override
  void dispose() {
    super.dispose();
    _tec.dispose();
    _focusNode
      ..removeListener(_handleFocus)
      ..dispose();
  }

  String? _handleValidate(String? text) {
    if (text == null || text.isEmpty) {
      return '댓글을 입력해주세요';
    }
    return null;
  }

  _handleSubmit() async {
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate();
    if (ok == null || !ok) return;
    await context.read<CreateParentPostCommentCubit>().submit(_tec.text.trim());
  }

  _handleFocus() {
    if (_focusNode.hasFocus) return;
    setState(() {
      _errorText = null;
    });
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
                key: _formKey,
                child: TextFormField(
                  validator: _handleValidate,
                  readOnly: !tappable,
                  controller: _tec,
                  focusNode: _focusNode,
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
