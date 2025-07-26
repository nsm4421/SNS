import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/data/model/auth_user.model.dart';
import 'package:sns/features/auth/data/model/request/edit_profile_request.model.dart';
import 'package:sns/features/auth/data/model/request/sign_up_request.model.dart';
import 'package:sns/features/auth/data/model/user.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'remote_auth.datasource.dart';

class RemoteAuthDataSourceImpl with AppLogger implements RemoteAuthDataSource {
  final GoTrueClient _auth;

  RemoteAuthDataSourceImpl(this._auth);

  @override
  Stream<AuthState> get authStateStream => _auth.onAuthStateChange;

  @override
  Future<AuthUserModel> getAuthUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('not logged in');
    }
    return AuthUserModel(
      id: user.id,
      email: user.email!,
      username: user.userMetadata!['username'],
    );
  }

  @override
  Future<String?> signUp(SignUpRequestModel dto) async {
    final response = await _auth.signUp(
      email: dto.email,
      password: dto.password,
      data: {
        'username': dto.username,
        if (dto.sex != null) 'sex': dto.sex,
        'description': dto.description,
      },
    );
    if (response.user == null) {
      throw const AuthException('sign up failed');
    }
    return response.user?.id;
  }

  @override
  Future<(String accessToken, String refreshToken)> signIn({
    required String email,
    required String password,
  }) async {
    final session = await _auth
        .signInWithPassword(email: email, password: password)
        .then((res) => res.session);

    if (session == null) {
      throw const AuthException('invalid session');
    } else if (session.accessToken.isEmpty) {
      throw const AuthException('access token is missing');
    } else if (session.refreshToken?.isEmpty != false) {
      throw const AuthException('refresh token is invalid');
    }

    return (session.accessToken, session.refreshToken!);
  }

  @override
  Future<String?> editProfile(EditProfileRequestModel dto) async {
    return await _auth
        .updateUser(
          UserAttributes(
            data: {
              if (dto.username != null) 'username': dto.username,
              if (dto.sex != null) 'sex': dto.sex,
              if (dto.description != null) 'description': dto.description,
            },
          ),
        )
        .then((res) => res.user?.id);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut(scope: SignOutScope.global);
  }

  @override
  Future<Session?> restoreSession(String refreshToken) async {
    return await _auth.setSession(refreshToken).then((res) => res.session);
  }
}
