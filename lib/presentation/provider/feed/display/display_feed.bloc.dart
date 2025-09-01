import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/entity/feed/feed.entity.dart';
import 'package:sns/domain/usecase/feed_usecases.dart';
import 'package:sns/domain/usecase/scenario/feed/fetch_feeds.usecase.dart';
import 'package:sns/presentation/provider/base/simple_display_bloc/simple_display.bloc.dart';

@injectable
class DisplayFeedBloc extends SimpleDisplayBloc<FeedEntity> {
  late final FetchFeedsUseCase _useCase;

  DisplayFeedBloc(FeedUseCases useCases) : super() {
    _useCase = useCases.fetchFeeds;
  }

  @override
  Future<Either<Failure, Page<FeedEntity>>> fetch({
    String? cursor,
    int limit = 20,
  }) async {
    return await _useCase.call(
      cursor: cursor ?? DateTime.now().toUtc().toIso8601String(),
      limit: limit,
    );
  }
}
