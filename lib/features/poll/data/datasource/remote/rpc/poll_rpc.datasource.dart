part of 'poll_rpc.datasource_impl.dart';

// 여러 테이블에 동시에 영향을 주는 경우 하나의 트랜젝션으로 관리하는 것이 편리
// 이러한 경우 RPC함수를 사용하였고, 이를 담당하는 DataSource
abstract mixin class $PollRpcDataSource {
  Future<String?> createTopic(CreateTopicRequestModel dto);

  Future<TopicDetailModel> getTopicDetail(GetTopicDetailRequestModel dto);
}
