import 'package:injectable/injectable.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/domain/repository/feed.repository.dart';

import 'scenario/feed/create_feed.usecase.dart';
import 'scenario/feed/fetch_feeds.usecase.dart';

@lazySingleton
class FeedUseCases with AppLogger {
  final FeedRepository _feedRepository;

  FeedUseCases(this._feedRepository);

  CreateFeedUseCase get createFeed =>
      CreateFeedUseCase(_feedRepository, logger: logger);

  FetchFeedsUseCase get fetchFeeds =>
      FetchFeedsUseCase(_feedRepository, logger: logger);
}
