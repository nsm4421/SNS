import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/data/model/user.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_user.datasorce.dart';

class RemoteUserDataSourceImpl with AppLogger implements RemoteUserDataSource {
  final PostgrestQueryBuilder _qb;

  RemoteUserDataSourceImpl(this._qb);

  @override
  Future<UserModel?> findByUId(String uid) async {
    final json = await _qb
        .select()
        .eq('id', uid)
        .limit(1)
        .then((res) => res.firstOrNull);
    logger.t('find user by id $uid, and fetched $json');
    return json == null ? null : UserModel.fromJson(json);
  }
}
