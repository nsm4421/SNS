import 'package:data/core/exception/api_exception.dart';
import 'package:data/datasource/database/database.dart';

part 'user_table.datasource.dart';

class UserTableDataSourceImpl implements UserTableDataSource {
  UserTableDataSourceImpl(this._usersTable);

  final UsersTable _usersTable;

  @override
  Future<UsersRow> findUserById(String uid) async {
    final res = await _usersTable.querySingleRow(
      queryFn: (q) => q.eq(UsersRow.idField, uid),
    );
    if (res == null) {
      throw ApiException.notFound('user not found');
    }
    return res;
  }
}
