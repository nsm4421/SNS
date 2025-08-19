import 'package:response_wrapper/api_exception/api_exception.dart';
import 'package:supabase_datasource/datasources/database/database_error_handler_mixin.dart';
import 'package:supabase_datasource/datasources/database/generated/tables/users.dart';
import 'package:supabase_datasource/datasources/database/user/user_table.datasource.dart';

class UserTableDataSourceImpl
    with DatabaseErrorHandlerMixIn
    implements UserTableDataSource {
  UserTableDataSourceImpl(this._usersTable);

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
