part of 'create_topic.cubit.dart';

@CopyWith()
class CreateTopicData {
  final String title;
  final String description;
  final List<String> options;

  CreateTopicData({
    required this.title,
    required this.description,
    required this.options,
  });
}
