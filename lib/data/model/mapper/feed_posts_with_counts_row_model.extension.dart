import 'package:sns/domain/entity/base/creator.entity.dart';
import 'package:sns/domain/entity/feed/feed_post.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension FeedPostsWithCountsRowExtension on FeedPostsWithCountsRow {
  FeedPostEntity toEntity() {
    return FeedPostEntity(
      id: id!,
      creator: CreatorEntity(id: authorId!, username: username!),
    );
  }
}
