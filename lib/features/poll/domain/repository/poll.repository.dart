import 'package:either_dart/either.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';

abstract interface class PollRepository {
  Future<Either<Failure, String>> createTopic({
    required String title,
    required String description,
    required List<String> options,
  });

  Future<Either<Failure, List<TopicEntity>>> fetchTopics({
    int limit = 20,
    DateTime? cursor,
    String? search,
  });

  Future<Either<Failure, TopicDetailEntity>> getTopicDetail(String topicId);

  Future<Either<Failure, void>> deleteTopic(String topicId);

  Future<Either<Failure, String>> upsertVote(String optionId);

  Future<Either<Failure, void>> deleteVote(String voteId);
}
