import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/domain/entity/topic_detail.entity.dart';

abstract interface class PollRepository {
  Future<String?> createTopic({
    required String title,
    required String description,
    required List<String> options,
  });

  Future<List<TopicEntity>> fetchTopics({
    int limit = 20,
    DateTime? cursor,
    String? search,
  });

  Future<TopicDetailEntity> getTopicDetail(String topicId);

  Future<void> deleteTopic(String topicId);

  Future<String> upsertVote(String optionId);

  Future<void> deleteVote(String voteId);
}
