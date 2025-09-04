import 'package:sns/domain/entity/base/creator.entity.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension FeedPostsWithCountsRowExtension on FeedWithImagesAndCountsRow {
  PostEntity toEntity() {
    return PostEntity(
      id: id!,
      creator: CreatorEntity(id: createdBy!, username: username!),
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
