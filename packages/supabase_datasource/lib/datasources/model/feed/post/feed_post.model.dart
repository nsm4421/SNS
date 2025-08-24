import 'package:freezed_annotation/freezed_annotation.dart';
import '../image/feed_post_image.model.dart';

part 'feed_post.model.freezed.dart';

part 'feed_post.model.g.dart';

@freezed
@JsonSerializable()
class FeedPostModel with _$FeedPostModel {
  final String id;
  @JsonKey(name: 'author_id')
  final String authorId;
  final String content;
  @JsonKey(name: 'is_public')
  @Default(true)
  final bool isPublic;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @Default(<FeedPostImageModel>[])
  final List<FeedPostImageModel> images;
  @JsonKey(name: 'likes_count')
  @Default(0)
  final int likesCount;
  @JsonKey(name: 'comments_count')
  @Default(0)
  final int commentsCount;
  final bool? likedByMe;

  FeedPostModel({
    required this.id,
    required this.authorId,
    this.content = '',
    this.isPublic = true,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.likedByMe = false,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) =>
      _$FeedPostModelFromJson(json);
}
