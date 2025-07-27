import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/poll/data/model/request/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/request/get_topic_detail_request.model.dart';
import 'package:sns/features/poll/data/model/topic_detail.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'poll_rpc.datasource.dart';

class $PollRpcDataSourceImpl with AppLogger implements $PollRpcDataSource {
  late final PostgrestFilterBuilder<T> Function<T>(
    String, {
    dynamic get,
    Map<String, dynamic>? params,
  })
  _rpc;

  $PollRpcDataSourceImpl(SupabaseClient supabaseClient) {
    _rpc = supabaseClient.rpc;
  }

  @override
  Future<String?> createTopic(CreateTopicRequestModel dto) async {
    try {
      final topicId = await _rpc<String?>(
        'create_topic_with_options',
        params: dto.toJson(),
      );
      return topicId;
    } on PostgrestException catch (error) {
      logger.e(error);
      rethrow;
    }
  }

  @override
  Future<TopicDetailModel> getTopicDetail(
    GetTopicDetailRequestModel dto,
  ) async {
    try {
      return await _rpc<Map<String, Object>>(
        'get_topic_detail',
        params: dto.toJson(),
      ).single().then(TopicDetailModel.fromJson);
    } on PostgrestException catch (error) {
      logger.e(error);
      rethrow;
    }
  }
}
