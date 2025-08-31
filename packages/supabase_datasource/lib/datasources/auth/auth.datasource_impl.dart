import 'package:shared/constant/auth_status.constant.dart';
import 'package:shared/response_wrapper/api_response/api_error_type.dart';
import 'package:shared/response_wrapper/api_response/api_exception.dart';
import 'package:supabase_datasource/datasources/model/auth/auth_user.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'package:supabase_datasource/datasources/auth/auth.datasource.dart';

class SupabaseAuthDataSourceImpl implements SupabaseAuthDataSource {
  SupabaseAuthDataSourceImpl(this._auth);

  final GoTrueClient _auth;

  @override
  Stream<AuthStatus> get authStatusStream async* {
    yield AuthStatus.checking; // 최초상태는 checking(인증상태 체크중)
    await for (final event in _auth.onAuthStateChange) {
      if (event.session?.user != null) {
        yield AuthStatus.authenticated;
      } else {
        yield AuthStatus.unauthenticated;
      }
    }
  }

  @override
  String? get currentUid => _auth.currentUser?.id;

  @override
  Future<AuthUserModel> getCurrentAuthUser() async {
    try {
      final data = _auth.currentUser?.userMetadata;
      if (data == null) {
        throw ApiException.auth("can't find current authenticated user");
      }
      return _tryParseAuthUser(data);
    } catch (e) {
      throw _toApiException(e);
    }
  }

  @override
  Future<(String, String?)> signUpAndReturnTokens({
    required String email,
    required String password,
    required String username,
    String? profileImage,
  }) async {
    try {
      final session = await _auth
          .signUp(
            email: email,
            password: password,
            data: {
              'email': email,
              'username': username,
              if (profileImage != null) 'profile_image': profileImage,
            },
          )
          .then((res) => res.session);
      if (session == null) {
        throw ApiException.notFound('session not found');
      }
      return (session.accessToken, session.refreshToken);
    } catch (e) {
      throw _toApiException(e);
    }
  }

  @override
  Future<(String, String?)> signInAndReturnTokens({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _auth
          .signInWithPassword(email: email, password: password)
          .then((res) => res.session);
      if (session == null) {
        throw ApiException.auth('session not found');
      }
      return (session.accessToken, session.refreshToken);
    } catch (e) {
      throw _toApiException(e);
    }
  }

  @override
  Future<(String, String?)> getNewTokensByRefreshToken(
    String refreshToken,
  ) async {
    try {
      final session = await _auth
          .setSession(refreshToken)
          .then((res) => res.session);
      if (session == null) {
        throw ApiException.auth('session not found');
      }
      return (session.accessToken, session.refreshToken);
    } catch (e) {
      throw _toApiException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut(scope: SignOutScope.global);
    } catch (e) {
      throw _toApiException(e);
    }
  }

  AuthUserModel _tryParseAuthUser(Map<String, dynamic> json) {
    try {
      return AuthUserModel.fromJson(json);
    } catch (e) {
      throw ApiException.auth('parsing auth model fails');
    }
  }

  ApiException _toApiException(Object error, {String? message}) {
    if (error is ApiException) {
      return error;
    } else if (error is AuthException) {
      final status = int.tryParse(error.statusCode ?? '') ?? 0;
      final type = switch (status) {
        401 => ApiErrorType.auth,
        403 => ApiErrorType.forbidden,
        408 => ApiErrorType.timeout,
        400 => ApiErrorType.validation,
        >= 500 => ApiErrorType.server,
        _ => ApiErrorType.unknown,
      };
      return ApiException.auth(message ?? error.message, type.code);
    } else {
      return ApiException.unknown(message);
    }
  }

}
