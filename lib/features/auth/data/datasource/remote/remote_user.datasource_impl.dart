import 'package:sns/core/response/datasource_response_wrapper_mixin.dart';
import 'package:sns/features/auth/data/model/user.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_user.datasorce.dart';

class RemoteUserDataSourceImpl
    with DataSourceResponseWrapperMixIn
    implements RemoteUserDataSource {
  late final PostgrestQueryBuilder _qb;

  RemoteUserDataSourceImpl(SupabaseClient supabaseClient) {
    _qb = supabaseClient.rest.from('users');
  }

  @override
  Future<UserModel> findByUId(String uid) async =>
      await guardApi<UserModel>(() async {
        return await _qb
            .select()
            .eq('id', uid)
            .limit(1)
            .then((res) => res.firstOrNull)
            .then((json) {
              if (json == null) {
                throw const PostgrestException(message: 'user not found');
              }
              return UserModel.fromJson(json);
            });
      });
}
