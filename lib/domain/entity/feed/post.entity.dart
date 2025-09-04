import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/domain/entity/base/creator.entity.dart';

part 'post.entity.g.dart';

@CopyWith(copyWithNull: true)
class PostEntity extends BaseEntityWithCreator {
  PostEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.creator,
    this.content = '',
    required this.images,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.likedByMe = false,
  });

  final String content;
  final List<String> images;
  final int commentsCount;
  final int likesCount;
  final bool likedByMe;
}
