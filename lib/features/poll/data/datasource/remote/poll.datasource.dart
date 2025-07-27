part of 'poll.datasource_impl.dart';

abstract interface class RemotePollDataSource {
  Future<String?> Function(CreateTopicRequestModel dto) get createTopic;

  Future<TopicDetailModel> Function(GetTopicDetailRequestModel dto)
  get getTopicDetail;

  Future<TopicModel> Function(String topicId) get findTopicById;

  Future<Iterable<TopicModel>> Function({
    int limit,
    DateTime? cursor, // created_at 커서
    String? search,
  })
  get fetchTopics;

  Future<void> Function(String topicId) get deleteTopicById;

  Future<String> Function(String optionId) get upsertVote;

  Future<void> Function(String voteId) get deleteVoteById;

  Future<void> Function(String optionId) get deleteVoteByOption;
}
