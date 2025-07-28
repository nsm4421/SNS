part of 'remote_topic.datasource_impl.dart';

abstract mixin class $RemoteTopicDataSource {
  Future<TopicModel> findById(String topicId);

  Future<Iterable<TopicModel>> fetchTopics({
    int limit = 20,
    DateTime? cursor, // created_at 커서
    String? search,
  });

  Future<void> deleteById(String topicId);
}
