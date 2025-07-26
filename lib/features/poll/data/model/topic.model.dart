import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/features/poll/data/model/option.model.dart';

part 'topic.model.g.dart';

part 'topic.model.freezed.dart';

@freezed
@JsonSerializable()
class TopicModel with _$TopicModel {
  final String id;
  final String title;
  final String description;
  final Iterable<OptionModel> options;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'created_by')
  final String createdBy;

  TopicModel({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    this.createdAt,
    required this.createdBy
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);
}
