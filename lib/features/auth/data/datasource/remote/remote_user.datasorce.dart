part of 'remote_user.datasource_impl.dart';

abstract interface class RemoteUserDataSource {
  Future<UserModel?> findByUId(String uid);
}
