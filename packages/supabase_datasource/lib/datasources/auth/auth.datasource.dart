import 'package:supabase_datasource/datasources/auth/model/auth_user.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SupabaseAuthDataSource {
  Stream<AuthState> get authStateStream;

  Future<AuthUserModel> getCurrentAuthUser();

  Future<(String accessToken, String? refreshToken)> signUpAndReturnTokens({
    required String email,
    required String password,
    required String username,
    String? profileImage,
  });

  Future<(String accessToken, String? refreshToken)> signInAndReturnTokens({
    required String email,
    required String password,
  });

  Future<(String accessToken, String? refreshToken)> getNewTokensByRefreshToken(
    String refreshToken,
  );

  Future<void> signOut();
}
