import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/core.export.dart';
import 'option.model.dart';

part 'topic_detail.model.g.dart';

part 'topic_detail.model.freezed.dart';

@freezed
@JsonSerializable()
class TopicDetailModel with _$TopicDetailModel implements BaseModelWithUser {
  @JsonKey(name: 'topic_id')
  final String id;
  @JsonKey(name: 'created_by')
  final String uid;
  @JsonKey(name: 'username')
  final String username;
  final String title;
  final String description;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final Iterable<OptionModel> options;

  TopicDetailModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    required this.options,
  });

  factory TopicDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TopicDetailModelFromJson(json);

  @override
  CreatorModel get creator => CreatorModel(id: uid, username: username);
}
