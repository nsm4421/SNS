import 'package:data/core/exception/api_exception.dart';
import 'package:data/model/features/auth/auth_user.model.dart';
import 'package:data/model/features/auth/sign_up_request.dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_auth.datasource.dart';

class SupabaseAuthDataSourceImpl implements SupabaseAuthDataSource {
  SupabaseAuthDataSourceImpl(SupabaseClient _client) {
    _auth = _client.auth;
  }

  late final GoTrueClient _auth;

  @override
  Stream<AuthState> get authStateStream => _auth.onAuthStateChange;

  @override
  Future<AuthUserModel> getCurrentAuthUser() async {
    final data = _auth.currentUser?.userMetadata;
    if (data == null) {
      throw ApiException.auth("can't find current authenticated user");
    }
    return AuthUserModel.fromJson(data);
  }

  @override
  Future<(String, String?)> signUpAndReturnTokens(
    SignUpRequestDto dto,
  ) async {
    final session = await _auth
        .signUp(
          email: dto.email,
          password: dto.password,
          data: dto.data,
        )
        .then((res) => res.session);
    if (session == null) {
      throw ApiException.notFound('session not found');
    }
    return (session.accessToken, session.refreshToken);
  }

  @override
  Future<(String, String?)> signInAndReturnTokens({
    required String email,
    required String password,
  }) async {
    final session = await _auth
        .signInWithPassword(email: email, password: password)
        .then((res) => res.session);
    if (session == null) {
      throw ApiException.auth('session not found');
    }
    return (session.accessToken, session.refreshToken);
  }

  @override
  Future<(String, String?)> getNewTokensByRefreshToken(
    String refreshToken,
  ) async {
    final session = await _auth
        .setSession(refreshToken)
        .then((res) => res.session);
    if (session == null) {
      throw ApiException.auth('session not found');
    }
    return (session.accessToken, session.refreshToken);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut(scope: SignOutScope.global);
  }
}
