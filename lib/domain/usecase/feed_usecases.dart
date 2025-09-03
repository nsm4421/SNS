import 'package:injectable/injectable.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/domain/repository/feed.repository.dart';

import 'scenario/feed/create_post.usecase.dart';
import 'scenario/feed/fetch_posts.usecase.dart';
import 'scenario/feed/toggle_post_like.usecase.dart';

@lazySingleton
class FeedUseCases with AppLogger {
  final FeedRepository _feedRepository;

  FeedUseCases(this._feedRepository);

  CreatePostUseCase get createPost =>
      CreatePostUseCase(_feedRepository, logger: logger);

  FetchPostsUseCase get fetchPosts =>
      FetchPostsUseCase(_feedRepository, logger: logger);

  TogglePostLikeUseCase get toggleLike =>
      TogglePostLikeUseCase(_feedRepository, logger: logger);
}
