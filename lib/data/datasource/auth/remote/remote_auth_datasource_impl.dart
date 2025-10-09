part of 'remote_auth_datasource.dart';

class SupabaseAuthDataSourceImpl implements RemoteAuthDataSource {
  final GoTrueClient _auth;
  final Logger? _logger;

  const SupabaseAuthDataSourceImpl(this._auth, {Logger? logger})
    : _logger = logger;

  @override
  String? get currentUserId => _auth.currentUser?.id;

  Stream<AuthStatusModel> get authStatusStream =>
      _auth.onAuthStateChange.asyncMap((e) {
        switch (e.event) {
          case AuthChangeEvent.initialSession:
          case AuthChangeEvent.signedIn:
            final supabaseUser = e.session?.user ?? _auth.currentUser;
            if (supabaseUser == null) {
              return const AuthStatusModel.unknown('app user is null');
            }
            final appUser = AppUserModel.fromSupabaseUser(supabaseUser);
            return AuthStatusModel.signedIn(
              user: appUser,
              accessToken: e.session?.accessToken,
              refreshToken: e.session?.refreshToken,
            );
          case AuthChangeEvent.signedOut:
            return const AuthStatusModel.signedOut();

          case AuthChangeEvent.tokenRefreshed:
            return AuthStatusModel.tokenRefreshed(
              accessToken: e.session?.accessToken,
              refreshToken: e.session?.refreshToken,
              user: e.session?.user != null
                  ? AppUserModel.fromSupabaseUser(e.session!.user)
                  : null,
            );

          case AuthChangeEvent.userUpdated:
            final supabaseUser = e.session?.user ?? _auth.currentUser;
            return supabaseUser == null
                ? const AuthStatusModel.unknown(
                    'userUpdated but given user is null',
                  )
                : AuthStatusModel.userUpdated(
                    user: AppUserModel.fromSupabaseUser(supabaseUser),
                  );
          default:
            return AuthStatusModel.unknown(e.event.name);
        }
      });

  @override
  Future<AuthResponseDto> signUp({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    try {
      final data = {
        'email': email,
        if (username != null) 'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };
      return await _auth
          // 회원가입 요청
          .signUp(email: email, password: password, data: data)
          .then((res) {
            if (res.user == null) {
              throw const AuthException('User is null after signUp');
            }
            // 회원가입 응답값 반환
            return AuthResponseDto(
              user: AppUserModel.fromSupabaseUser(res.user!),
              needsEmailConfirmation: res.session == null,
              accessToken: res.session?.accessToken,
              refreshToken: res.session?.refreshToken,
            );
          });
    } on AuthException catch (e, st) {
      _logger?.e(e, stackTrace: st);
      if (e.code == '400' ||
          e.message.toLowerCase().contains('already registered')) {
        throw CustomException.auth(
          message: 'email already registered',
          code: ErrorCode.conflict,
        );
      }
      throw CustomException.auth();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AppUserModel> getCurrentUser() async {
    final supabaseUser = _auth.currentUser;
    if (supabaseUser == null) {
      throw CustomException.auth(
        message: 'current user is not found',
        code: ErrorCode.notFound,
      );
    }
    return AppUserModel.fromSupabaseUser(supabaseUser);
  }

  @override
  Future<AuthResponseDto> refreshSession() async {
    return _auth.refreshSession().then((res) {
      if (res.user == null || res.session == null) {
        throw CustomException.auth(
          message: 'session refreshed but user, session is null',
          code: ErrorCode.notFound,
        );
      }
      return AuthResponseDto(
        user: AppUserModel.fromSupabaseUser(res.user!),
        accessToken: res.session?.accessToken,
        refreshToken: res.session?.refreshToken,
      );
    });
  }

  @override
  Future<AuthResponseDto> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (res.user == null || res.session == null) {
        throw CustomException.auth(
          message: 'log in, but user, session is null',
        );
      }

      return AuthResponseDto(
        user: AppUserModel.fromSupabaseUser(res.user!),
        accessToken: res.session?.accessToken,
        refreshToken: res.session?.refreshToken,
      );
    } on AuthException catch (e, st) {
      if (e.statusCode == '400' ||
          e.message.toLowerCase().contains('invalid') ||
          e.message.toLowerCase().contains('credential')) {
        throw CustomException.auth(
          message: 'email or password is wrong',
          code: ErrorCode.invalidCredential,
        );
      }
      if (e.statusCode == '429' ||
          e.message.toLowerCase().contains('too many')) {
        throw CustomException.auth(
          message: e.message,
          code: ErrorCode.ratedLimited,
        );
      }
      throw CustomException.auth(code: ErrorCode.internalServer);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut(scope: SignOutScope.global);
    } on AuthException catch (e, st) {
      _logger?.e(e, stackTrace: st);
      throw CustomException.auth(
        message: e.message,
        code: ErrorCode.internalServer,
      );
    } catch (e, st) {
      _logger?.e(e, stackTrace: st);
      rethrow;
    }
  }
}
