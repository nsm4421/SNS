import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_feed_post_request.model.freezed.dart';

part 'create_feed_post_request.model.g.dart';

@freezed
@JsonSerializable()
class CreateFeedPostRequestModel with _$CreateFeedPostRequestModel {
  @JsonKey(name: 'id')
  final String postId;
  final String content;
  @JsonKey(name: 'is_public')
  @Default(true)
  final bool isPublic;

  CreateFeedPostRequestModel({
    required this.postId,
    required this.content,
    this.isPublic = true,
  });

  factory CreateFeedPostRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateFeedPostRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFeedPostRequestModelToJson(this);
}
