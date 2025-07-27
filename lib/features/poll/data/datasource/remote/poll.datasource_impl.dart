import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:sns/features/poll/data/model/request/create_topic_request.model.dart';
import 'package:sns/features/poll/data/model/request/get_topic_detail_request.model.dart';
import 'package:sns/features/poll/data/model/topic.model.dart';
import 'package:sns/features/poll/data/model/topic_detail.model.dart';

import 'table/remote_vote.datasource_impl.dart';

import 'table/remote_topic.datasource_impl.dart';

import 'rpc/poll_rpc.datasource_impl.dart';

part 'poll.datasource.dart';

class RemotePollDataSourceImpl implements RemotePollDataSource {
  late final $PollRpcDataSourceImpl _pollRpc;
  late final $RemoteTopicDataSourceImpl _topicDataSource;
  late final $RemoteVoteDataSourceImpl _voteDataSource;

  RemotePollDataSourceImpl(SupabaseClient supabaseClient) {
    _pollRpc = $PollRpcDataSourceImpl(supabaseClient);
    _topicDataSource = $RemoteTopicDataSourceImpl(supabaseClient);
    _voteDataSource = $RemoteVoteDataSourceImpl(supabaseClient);
  }

  @override
  Future<String?> Function(CreateTopicRequestModel dto) get createTopic =>
      _pollRpc.createTopic;

  @override
  Future<TopicDetailModel> Function(GetTopicDetailRequestModel dto)
  get getTopicDetail => _pollRpc.getTopicDetail;

  @override
  Future<void> Function(String topicId) get deleteTopicById =>
      _topicDataSource.delete;

  @override
  Future<Iterable<TopicModel>> Function({
    DateTime? cursor,
    int limit,
    String? search,
  })
  get fetchTopics => _topicDataSource.fetchTopics;

  @override
  Future<TopicModel> Function(String topicId) get findTopicById =>
      _topicDataSource.findById;

  @override
  Future<String> Function(String optionId) get upsertVote =>
      _voteDataSource.upsert;

  @override
  Future<void> Function(String voteId) get deleteVoteById =>
      _voteDataSource.delete;

  @override
  Future<void> Function(String optionId) get deleteVoteByOption =>
      _voteDataSource.deleteByOption;
}
