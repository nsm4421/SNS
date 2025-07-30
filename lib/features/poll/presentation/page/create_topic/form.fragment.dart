import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/features/poll/presentation/bloc/create_topic.cubit.dart';

class CreateTopicFragment extends StatefulWidget {
  const CreateTopicFragment({super.key});

  @override
  State<CreateTopicFragment> createState() => _CreateTopicFragmentState();
}

class _CreateTopicFragmentState extends State<CreateTopicFragment> {
  static const int _maxOptionLength = 5;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _optionController;
  late final FocusNode _titleFocus;
  late final FocusNode _descriptionFocus;
  late final FocusNode _optionFocus;
  late final List<String> _options;

  String? _optionErrorText;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _optionController = TextEditingController();
    _titleFocus = FocusNode()..addListener(_handleTitleFocus);
    _descriptionFocus = FocusNode()..addListener(_handleDescriptionFocus);
    _optionFocus = FocusNode();
    _options = [];
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _optionController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _optionFocus.dispose();
  }

  _handleTitleFocus() {
    if (_titleFocus.hasFocus) return;
    context.read<CreateTopicCubit>().updateTitle(_titleController.text.trim());
  }

  _handleDescriptionFocus() {
    if (_descriptionFocus.hasFocus) return;
    context.read<CreateTopicCubit>().updateDescription(
      _descriptionController.text.trim(),
    );
  }

  _handleAddOption() {
    final text = _optionController.text.trim();
    if (_options.length >= _maxOptionLength || text.isEmpty) {
      return;
    }
    if (_options.contains(text)) {
      setState(() {
        _optionErrorText = 'duplicated hashtag';
      });
      return;
    }
    setState(() {
      _optionErrorText = null;
      _options.add(text);
    });
    context.read<CreateTopicCubit>().addOption(text);
    _optionController.clear();
  }

  _removeOptionByIndex(int index) => () {
    setState(() {
      _options.removeAt(index);
    });
    context.read<CreateTopicCubit>().removeOptionByIndex(index);
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<CreateTopicCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextFormField(
              controller: _titleController,
              focusNode: _titleFocus,
              decoration: const InputDecoration(
                hintText: 'Title',
                prefixIcon: Icon(Icons.title_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextFormField(
              controller: _descriptionController,
              focusNode: _descriptionFocus,
              decoration: const InputDecoration(
                hintText: 'Description',
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextFormField(
              readOnly: _options.length >= _maxOptionLength,
              controller: _optionController,
              focusNode: _optionFocus,
              decoration: InputDecoration(
                hintText: 'Option',
                errorText: _optionErrorText,
                prefixIcon: const Icon(Icons.how_to_vote_outlined),
                suffixIcon: IconButton(
                  onPressed: _options.length < _maxOptionLength
                      ? _handleAddOption
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ),
            ),
          ),

          if (_options.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _options.indexed
                    .map(
                      (e) => ListTile(
                        leading: Text((e.$1 + 1).toString()),
                        title: Text(e.$2),
                        trailing: IconButton(
                          onPressed: _removeOptionByIndex(e.$1),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
