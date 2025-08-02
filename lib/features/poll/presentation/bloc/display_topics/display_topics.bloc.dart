import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/usecase/poll.usecases.dart';

@injectable
class DisplayTopicBloc extends SimpleDisplayBloc<TopicEntity> {
  late final FetchTopicsUseCase _useCase;

  DisplayTopicBloc(PollUseCases useCases)
    : super(SimpleDisplayState<TopicEntity>(data: [])) {
    _useCase = useCases.fetchTopics;
  }

  @override
  Future<Either<Failure, List<TopicEntity>>> fetch({
    DateTime? cursor,
    int limit = 20,
  }) async {
    logger.t('[fetch data] cursor:$cursor | limit:$limit');
    return _useCase.call(cursor: cursor, limit: limit);
  }
}
