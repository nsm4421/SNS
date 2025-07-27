part of 'remote_vote.datasource_impl.dart';

abstract mixin class $RemoteVoteDataSource {
  Future<String> upsert(String optionId);

  Future<void> delete(String voteId);

  Future<void> deleteByOption(String optionId);
}
