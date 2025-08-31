import 'package:copy_with_extension/copy_with_extension.dart';

import '../base/creator.entity.dart';

part 'feed_post.entity.g.dart';

@CopyWith(copyWithNull: true)
class FeedPostEntity extends BaseEntityWithCreator {
  FeedPostEntity({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required super.creator,
    this.content = '',
  });

  final String content;
}
