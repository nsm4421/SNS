import 'package:sns/core/response/datasource_response_wrapper_mixin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_vote.datasource.dart';

class $RemoteVoteDataSourceImpl
    with DataSourceResponseWrapperMixIn
    implements $RemoteVoteDataSource {
  late final PostgrestQueryBuilder _qb;
  late final String _currentUid;

  $RemoteVoteDataSourceImpl(SupabaseClient supabaseClient) {
    _qb = supabaseClient.rest.from('votes');
    _currentUid = supabaseClient.auth.currentUser!.id;
  }

  @override
  Future<String> upsert(String optionId) async =>
      await guardApi<String>(() async {
        return await _qb
            .upsert({'option_id': optionId}, onConflict: 'option_id,created_by')
            .select()
            .single()
            .then((json) => json['id']);
      });

  @override
  Future<void> delete(String voteId) async => await guardApi<void>(() async {
    await _qb.delete().eq("id", voteId);
  });

  @override
  Future<void> deleteByOption(String optionId) async =>
      await guardApi<void>(() async {
        await _qb
            .delete()
            .eq("option_id", optionId)
            .eq("created_by", _currentUid);
      });
}
