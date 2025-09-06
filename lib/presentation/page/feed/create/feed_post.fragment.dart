part of 'create_post.page.dart';

class FeedPostFragment extends StatefulWidget {
  const FeedPostFragment({super.key});

  @override
  State<FeedPostFragment> createState() => _FeedPostFragmentState();
}

class _FeedPostFragmentState extends State<FeedPostFragment> {
  static const int _minLines = 5;
  static const int _maxLines = 20;
  static const int _maxLength = 1000;
  static const int _minLength = 3;

  late final TextEditingController _contentTec;

  @override
  void initState() {
    super.initState();
    _contentTec = TextEditingController()
      ..addListener(_handleChange)
      ..text = context.read<CreateFeedCubit>().state.data.content;
  }

  @override
  void dispose() {
    super.dispose();
    _contentTec
      ..removeListener(_handleChange)
      ..dispose();
  }

  String? _handleValidate(String? v) {
    if (v == null || v.isEmpty) {
      return '본문을 작성해주세요';
    } else if (v.length < _minLength) {
      return '최소 $_minLength자로 작성해주세요';
    }
    return null;
  }

  void _handleChange() {
    context.read<CreateFeedCubit>().updateContent(_contentTec.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Content', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contentTec,
          validator: _handleValidate,
          minLines: _minLines,
          maxLines: _maxLines,
          maxLength: _maxLength,
        ),
      ],
    );
  }
}
