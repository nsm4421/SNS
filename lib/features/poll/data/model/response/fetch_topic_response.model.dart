import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_topic_response.model.g.dart';

part 'fetch_topic_response.model.freezed.dart';

@freezed
@JsonSerializable()
class FetchTopicResponseModel with _$FetchTopicResponseModel {
  @JsonKey(name: "topic_id")
  final String topicId;
  @JsonKey(name: "created_by")
  final String createdBy;
  final String title;
  final String description;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  final List<$Item> options;

  FetchTopicResponseModel({
    required this.topicId,
    required this.createdBy,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    required this.options,
  }) {
    if (options.length < 2) {
      throw Exception('send at least 2 options');
    }
  }

  factory FetchTopicResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FetchTopicResponseModelFromJson(json);
}

@freezed
@JsonSerializable()
class $Item with _$$Item {
  final String id;
  final String content;
  @JsonKey(name: "vote_count")
  final int voteCount;
  @JsonKey(name: "vote_by_me")
  final bool voteByMe;

  $Item({
    required this.id,
    required this.content,
    this.voteCount = 0,
    this.voteByMe = false,
  });

  factory $Item.fromJson(Map<String, dynamic> json) =>
      _$$ItemFromJson(json);
}
