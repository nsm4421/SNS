import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/core/response/repository_response_wrapper_mixin.dart';
import 'package:sns/features/poll/data/datasource/remote/poll.datasource_impl.dart';
import 'package:sns/features/poll/data/model/request/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/request/get_topic_detail_request.model.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

@LazySingleton(as: PollRepository)
class PollRepositoryImpl
    with ResponseResponseWrapperMixIn
    implements PollRepository {
  final RemotePollDataSource _remoteDataSource;

  PollRepositoryImpl({required RemotePollDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, String>> createTopic({
    required String title,
    required String description,
    required List<String> options,
  }) async => await guardApi(() async {
    return await _remoteDataSource.createTopic(
      CreateTopicRequestModel(
        title: title,
        description: description,
        options: options,
      ),
    );
  });

  @override
  Future<Either<Failure, List<TopicEntity>>> fetchTopics({
    int limit = 20,
    DateTime? cursor,
    String? search,
  }) async => await guardApi(() async {
    return await _remoteDataSource
        .fetchTopics(limit: limit, cursor: cursor, search: search)
        .then((res) => res.map(TopicEntity.fromModel).toList());
  });

  @override
  Future<Either<Failure, TopicDetailEntity>> getTopicDetail(
    String topicId,
  ) async => await guardApi(() async {
    return await _remoteDataSource
        .getTopicDetail(GetTopicDetailRequestModel(topicId: topicId))
        .then(TopicDetailEntity.fromModel);
  });

  @override
  Future<Either<Failure, String>> upsertVote(String optionId) async =>
      await guardApi(() async {
        return await _remoteDataSource.upsertVote(optionId);
      });

  @override
  Future<Either<Failure, void>> deleteTopic(String topicId) async =>
      await guardApi(() async {
        await _remoteDataSource.deleteTopicById(topicId);
      });

  @override
  Future<Either<Failure, void>> deleteVote(String voteId) async =>
      await guardApi(() async {
        await _remoteDataSource.deleteVoteById(voteId);
      });
}
