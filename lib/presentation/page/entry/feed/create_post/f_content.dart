part of 'p_create_post.dart';

class _ContentFragment extends StatefulWidget {
  const _ContentFragment({super.key});

  @override
  State<_ContentFragment> createState() => _ContentFragmentState();
}

class _ContentFragmentState extends State<_ContentFragment> {
  static const int _minLines = 3;
  static const int _maxLines = 10;
  static const int _maxLength = 1000;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_handleChange);
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_handleChange)
      ..dispose();
  }

  _handleChange() {
    context.read<CreatePostCubit>().updateContent(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('CONTENT', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context, state) {
            return TextField(
              readOnly: state.status != ComposeStatus.idle,
              minLines: _minLines,
              maxLines: _maxLines,
              maxLength: _maxLength,
              controller: _controller,
              decoration: const InputDecoration(hintText: 'post body'),
            );
          },
        ),
      ],
    );
  }
}
