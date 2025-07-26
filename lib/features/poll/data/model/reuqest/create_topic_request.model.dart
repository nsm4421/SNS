import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_topic_request.model.g.dart';

part 'create_topic_request.model.freezed.dart';

@freezed
@JsonSerializable()
class CreateTopicRequestModel with _$CreateTopicRequestModel {
  final String title;
  final String description;
  final List<String> options;

  CreateTopicRequestModel({
    required this.title,
    required this.description,
    required this.options,
  }) {
    if (options.length < 2) {
      throw Exception('send at least 2 options');
    }
  }

  factory CreateTopicRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTopicRequestModelFromJson(json);
}
