import 'package:either_dart/either.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';

abstract interface class PollRepository {
  Future<Either<ApiError, String>> createTopic({
    required String title,
    required String description,
    required List<String> options,
  });

  Future<Either<ApiError, List<TopicEntity>>> fetchTopics({
    int limit = 20,
    DateTime? cursor,
    String? search,
  });

  Future<Either<ApiError, TopicDetailEntity>> getTopicDetail(String topicId);

  Future<Either<ApiError, void>> deleteTopic(String topicId);

  Future<Either<ApiError, String>> upsertVote(String optionId);

  @Deprecated('use deleteVoteByOption instead')
  Future<Either<ApiError, void>> deleteVote(String voteId);

  Future<Either<ApiError, void>> deleteVoteByOption(String optionId);
}
