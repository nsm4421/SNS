import 'package:shared/response_wrapper/api_response/api_exception.dart';
import 'package:supabase_datasource/datasources/database/features/database_error_handler_mixin.dart';
import 'package:supabase_datasource/datasources/database/generated/tables/users.dart';

part 'user.datasource.dart';

class UserDataSourceImpl
    with DatabaseErrorHandlerMixIn
    implements UserDataSource {
  UserDataSourceImpl(this._usersTable);

  final UsersTable _usersTable;

  @override
  Future<UsersRow> findUserById(String uid) async {
    try {
      final res = await _usersTable.querySingleRow(
        queryFn: (q) => q.eq(UsersRow.idField, uid),
      );
      if (res == null) {
        throw ApiException.notFound('user not found');
      }
      return res;
    } catch (e) {
      throw toApiException(e);
    }
  }
}
