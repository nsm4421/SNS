import 'package:injectable/injectable.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';
import 'scenario/cancel_vote.usecase.dart';
import 'scenario/cast_vote.usecase.dart';
import 'scenario/create_topic.usecase.dart';
import 'scenario/delete_topic.usecase.dart';
import 'scenario/fetch_topics.usecase.dart';
import 'scenario/get_topic_detail.usecase.dart';

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
