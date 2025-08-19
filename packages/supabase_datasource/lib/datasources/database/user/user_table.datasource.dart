import 'package:supabase_datasource/datasources/database/generated/tables/users.dart';

abstract interface class UserTableDataSource {
  Future<UsersRow> findUserById(String uid);
}
