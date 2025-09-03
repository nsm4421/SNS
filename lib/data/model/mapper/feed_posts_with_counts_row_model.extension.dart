import 'package:sns/domain/entity/base/creator.entity.dart';
import 'package:sns/domain/entity/feed/feed.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension FeedPostsWithCountsRowExtension on FeedWithImagesAndCountsRow {
  FeedEntity toEntity() {
    return FeedEntity(
      id: id!,
      creator: CreatorEntity(id: authorId!, username: authorUsername!),
      createdAt: createdAt,
      updatedAt: updatedAt,
      content: content ?? '',
      likesCount: likesCount ?? 0,
      commentsCount: commentsCount ?? 0,
      images: images,
      likedByMe: likedByMe ?? false,
    );
  }
}
