part of 'user.datasource_impl.dart';

abstract interface class UserDataSource {
  Future<UsersRow> findUserById(String uid);
}
