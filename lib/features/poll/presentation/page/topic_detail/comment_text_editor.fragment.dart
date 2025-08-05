import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/comment.export.dart';

class CommentTextEditorFragment extends StatefulWidget {
  const CommentTextEditorFragment({super.key});

  @override
  State<CommentTextEditorFragment> createState() =>
      _CommentTextEditorFragmentState();
}

class _CommentTextEditorFragmentState extends State<CommentTextEditorFragment> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late bool _isBorderVisible;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_handleFocus);
    _isBorderVisible = _focusNode.hasFocus;
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode
      ..removeListener(_handleFocus)
      ..dispose();
  }

  _handleFocus() {
    setState(() {
      _isBorderVisible = _focusNode.hasFocus;
    });
    if (!_focusNode.hasFocus) {
      context.read<CreateTopicCommentCubit>().updateContent(
        _controller.text.trim(),
      );
    }
  }

  _handleSubmit() async {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();
    final ok = _formKey.currentState?.validate();
    if (ok == null || !ok) {
      return;
    }
    await Future.delayed(const Duration(microseconds: 200));
    await context.read<CreateTopicCommentCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTopicCommentCubit, SimpleCubitState<String>>(
      listenWhen: (prev, curr) => curr.status == Status.success,
      listener: (context, state) {
        _controller.clear();
        context.read<DisplayTopicCommentsBloc>().add(RefreshDisplayEvent());
      },
      child: BlocBuilder<CreateTopicCommentCubit, SimpleCubitState<String>>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'write comment',
                border: _isBorderVisible
                    ? const OutlineInputBorder()
                    : InputBorder.none,
                prefixIcon: const Icon(Icons.insert_comment_outlined),
                suffixIcon: state.status == Status.loading
                    ? Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(),
                      )
                    : IconButton(
                        onPressed: _handleSubmit,
                        icon: const Icon(Icons.chevron_right),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
