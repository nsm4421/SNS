import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

part 'scenario/cancel_vote.usecase.dart';

part 'scenario/cast_vote.usecase.dart';

part 'scenario/create_topic.usecase.dart';

part 'scenario/delete_topic.usecase.dart';

part 'scenario/fetch_topics.usecase.dart';

part 'scenario/get_topic_detail.usecase.dart';

@lazySingleton
class PollUseCases {
  final PollRepository _repository;

  PollUseCases(this._repository);

  CreateTopicUseCase get createTopic => CreateTopicUseCase(_repository);

  DeleteTopicUseCase get deleteTopic => DeleteTopicUseCase(_repository);

  FetchTopicsUseCase get fetchTopics => FetchTopicsUseCase(_repository);

  GetTopicDetailUseCase get getTopicDetail =>
      GetTopicDetailUseCase(_repository);

  CastVoteUseCase get castVote => CastVoteUseCase(_repository);

  CancelVoteUseCase get cancelVote => CancelVoteUseCase(_repository);
}
