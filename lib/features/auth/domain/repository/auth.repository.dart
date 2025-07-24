import 'package:sns/core/constant/auth_state.constant.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get authStatusStream;

  Future<bool> getIsAuth();

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> restoreSession();
}
