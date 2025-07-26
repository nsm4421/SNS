import 'dart:math';

import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/poll/data/model/response/fetch_topic_response.model.dart';
import 'package:sns/features/poll/data/model/reuqest/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/topic.model.dart';
import 'package:sns/features/poll/data/model/vote.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_poll.datasource.dart';

class RemotePollDataSourceImpl with AppLogger implements RemotePollDataSource {
  late final PostgrestQueryBuilder _topicQb;
  late final PostgrestQueryBuilder _voteQb;
  late final PostgrestFilterBuilder<T> Function<T>(
    String, {
    dynamic get,
    Map<String, dynamic>? params,
  })
  _rpc;

  RemotePollDataSourceImpl(SupabaseClient supabaseClient) {
    _topicQb = supabaseClient.rest.from('topics');
    _voteQb = supabaseClient.rest.from('votes');
    _rpc = supabaseClient.rpc;
  }

  @override
  Future<String?> createTopic(CreateTopicRequestModel dto) async {
    try {
      final topicId = await _rpc<String?>(
        'create_topic_with_options',
        params: {
          'p_title': dto.title,
          'p_description': dto.description,
          'p_options': dto.options,
        },
      );
      return topicId;
    } on PostgrestException catch (error) {
      logger.e(error);
      rethrow;
    }
  }

  @override
  Future<TopicModel> findTopicById(String topicId) async {
    return await _topicQb
        .select(
          'id, title, description, created_at, created_by,'
          'options(id, content, children:votes(count))',
        )
        .eq('id', topicId)
        .single()
        .then(TopicModel.fromJson);
  }

  @override
  Future<Iterable<FetchTopicResponseModel>> fetchTopics({
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    try {
      return await _rpc<List<Map<String, dynamic>>>(
        'get_topics_with_votes',
        params: {'p_limit': limit, 'p_offset': offset, 'p_search': search},
      ).then((res) => res.map(FetchTopicResponseModel.fromJson));
    } on PostgrestException catch (error) {
      logger.e(error);
      rethrow;
    }
  }

  @override
  Future<void> deleteTopicById(String topicId) async {
    await _topicQb.delete().eq('id', topicId);
  }

  @override
  Future<void> deleteVoteById(String voteId) async {
    await _voteQb.delete().eq('id', voteId);
  }

  @override
  Future<String> upsertVoteByOptionId(String optionId) async {
    return await _voteQb
        .upsert({'option_id': optionId}, onConflict: 'option_id,created_by')
        .select()
        .single()
        .then(VoteModel.fromJson)
        .then((model) => model.id);
  }
}
