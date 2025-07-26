part of 'remote_poll.datasource_impl.dart';

abstract interface class RemotePollDataSource {
  Future<String?> createTopic(CreateTopicRequestModel dto);

  Future<String> upsertVoteByOptionId(String optionId);

  Future<void> deleteVoteById(String voteId);

  Future<TopicModel> findTopicById(String topicId);

  Future<Iterable<FetchTopicResponseModel>> fetchTopics({
    int limit = 20,
    int offset = 0,
    String? search,
  });

  Future<void> deleteTopicById(String topicId);
}
