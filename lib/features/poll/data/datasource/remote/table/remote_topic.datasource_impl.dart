import 'package:sns/features/poll/data/model/topic.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_topic.datasource.dart';

class $RemoteTopicDataSourceImpl implements $RemoteTopicDataSource {
  late final PostgrestQueryBuilder _qb;

  $RemoteTopicDataSourceImpl(SupabaseClient supabaseClient) {
    _qb = supabaseClient.rest.from('topics');
  }

  @override
  Future<TopicModel> findById(String topicId) async {
    return await _qb
        .select('*')
        .eq('id', topicId)
        .single()
        .then(TopicModel.fromJson);
  }

  @override
  Future<Iterable<TopicModel>> fetchTopics({
    int limit = 20,
    DateTime? cursor,
    String? search,
  }) async {
    final query = _qb.select('*');
    if (search != null && search.isNotEmpty) {
      query.ilike('title', '%$search%');
    }
    if (cursor != null) {
      query.lt('created_at', cursor.toIso8601String());
    }
    return await query
        .order('created_at')
        .limit(limit)
        .then((res) => res.map(TopicModel.fromJson));
  }

  @override
  Future<void> delete(String topicId) async {
    await _qb.delete().eq('id', topicId);
  }
}
