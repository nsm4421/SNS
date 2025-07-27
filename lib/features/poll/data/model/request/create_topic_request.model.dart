import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_topic_request.model.g.dart';

part 'create_topic_request.model.freezed.dart';

@freezed
@JsonSerializable()
class CreateTopicRequestModel with _$CreateTopicRequestModel {
  @JsonKey(name: 'p_title')
  final String title;
  @JsonKey(name: 'p_description')
  final String description;
  @JsonKey(name: 'p_options')
  final List<String> options;

  CreateTopicRequestModel({
    required this.title,
    required this.description,
    required this.options,
  }) {
    if (options.length < 2) {
      throw Exception('at least use 2 options');
    }
  }

  factory CreateTopicRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTopicRequestModelFromJson(json);

  Map<String, Object?> toJson() => _$CreateTopicRequestModelToJson(this);
}
