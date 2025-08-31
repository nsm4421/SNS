import 'package:injectable/injectable.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/domain/repository/feed.repository.dart';

import 'package:sns/domain/usecase/screnario/feed/create_feed.usecase.dart';

@lazySingleton
class FeedUseCases with AppLogger {
  final FeedRepository _feedRepository;

  FeedUseCases(this._feedRepository);

  CreateFeedUseCase get createFeed =>
      CreateFeedUseCase(_feedRepository, logger: logger);
}
