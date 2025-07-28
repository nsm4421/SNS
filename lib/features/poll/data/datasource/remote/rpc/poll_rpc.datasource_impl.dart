import 'package:sns/features/poll/data/model/request/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/request/get_topic_detail_request.model.dart';
import 'package:sns/features/poll/data/model/topic_detail.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'poll_rpc.datasource.dart';

class $PollRpcDataSourceImpl implements $PollRpcDataSource {
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
  Future<String> createTopicAndReturnId(CreateTopicRequestModel dto) async {
    return await _rpc<String>(
      'create_topic_with_options',
      params: dto.toJson(),
    );
  }

  @override
  Future<TopicDetailModel> getTopicDetail(
    GetTopicDetailRequestModel dto,
  ) async {
    return await _rpc<Map<String, Object>>(
      'get_topic_detail',
      params: dto.toJson(),
    ).single().then(TopicDetailModel.fromJson);
  }
}
