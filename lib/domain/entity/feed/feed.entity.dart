import 'package:copy_with_extension/copy_with_extension.dart';

import '../base/creator.entity.dart';

part 'feed.entity.g.dart';

@CopyWith(copyWithNull: true)
class FeedEntity extends BaseEntityWithCreator {
  FeedEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.creator,
    this.content = '',
    required this.images,
    required this.widths,
    required this.heights,
    this.commentsCount = 0,
    this.likesCount = 0,
  });

  final String content;
  final List<String> images;
  final List<int> widths;
  final List<int> heights;
  final int commentsCount;
  final int likesCount;
}
