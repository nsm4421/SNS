import 'package:injectable/injectable.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/comment/feed_post_comments.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/feed.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/image/feed_post_images.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/like/feed_post_likes.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/feed/post/feed_posts.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/features/user/user.datasource_impl.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';
import 'package:supabase_datasource/datasources/storage/storage.datasource_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class SupabaeDataSourceModule {
  final SupabaseClient _client = Supabase.instance.client;

  /// auth
  @lazySingleton
  SupabaseAuthDataSource get authDataSource =>
      SupabaseAuthDataSourceImpl(_client.auth);

  /// storage
  @lazySingleton
  SupabaseStorageDataSource get storageDataSource =>
      SupabaseStorageDataSourceImpl(_client.storage);

  /// user
  @lazySingleton
  UsersTable get _usersTable => UsersTable();

  @lazySingleton
  UserDataSource get userDataSource => UserDataSourceImpl(_usersTable);

  /// feed
  @lazySingleton
  FeedPostsTable get _feedPostsTable => FeedPostsTable();

  @lazySingleton
  FeedPostsWithCountsTable get _feedPostsWithCountsTable =>
      FeedPostsWithCountsTable();

  @lazySingleton
  FeedPostLikesTable get _feedPostLikesTable => FeedPostLikesTable();

  @lazySingleton
  FeedPostCommentsTable get _feedPostCommentsTable => FeedPostCommentsTable();

  @lazySingleton
  FeedPostImagesTable get _feedPostImagesTable => FeedPostImagesTable();

  @lazySingleton
  FeedPostDataSource get _feedPostDataSource => FeedPostDataSourceImpl(
    feedPostsTable: _feedPostsTable,
    feedPostsWithCountsTable: _feedPostsWithCountsTable,
  );

  @lazySingleton
  FeedPostLikeDataSource get _feedLikeDataSource => FeedPostLikeDataSourceImpl(
    client: _client,
    feedPostLikesTable: _feedPostLikesTable,
    feedPostsWithCountsTable: _feedPostsWithCountsTable,
  );

  @lazySingleton
  FeedPostCommentDataSource get _feedCommentDataSource =>
      FeedPostCommentDataSourceImpl(
        feedPostCommentsTable: _feedPostCommentsTable,
        feedPostsWithCountsTable: _feedPostsWithCountsTable,
      );

  @lazySingleton
  FeedPostImageDataSource get _feedPostImagesDataSource =>
      FeedPostImageDataSourceImpl(_feedPostImagesTable);

  @lazySingleton
  FeedDatabaseDataSource get feedTable => FeedDataSourceImpl(
    feedPostDataSource: _feedPostDataSource,
    feedLikeDataSource: _feedLikeDataSource,
    feedCommentDataSource: _feedCommentDataSource,
    feedPostImagesDataSource: _feedPostImagesDataSource,
  );
}
