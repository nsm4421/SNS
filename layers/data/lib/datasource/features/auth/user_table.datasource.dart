part of 'user_table.datasource_impl.dart';

abstract interface class UserTableDataSource {
  Future<UsersRow> findUserById(String uid);
}
