part of 'auth_datasource.dart';

class SupabaseAuthDataSourceImpl implements AuthDatasource {
  final GoTrueClient _auth;

  SupabaseAuthDataSourceImpl(this._auth);

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
  Future<SignUpResponseDto> signUp(SignUpRequestDto request) async {
    try {
      return await _auth
          // 회원가입 요청
          .signUp(
            email: request.email,
            password: request.password,
            data: {
              if (request.username != null) 'username': request.username,
              if (request.avatarUrl != null) 'avatar_url': request.avatarUrl,
            },
          )
          .then((res) {
            if (res.user == null) {
              throw const AuthException('User is null after signUp');
            }
            // 회원가입 응답값 반환
            return SignUpResponseDto(
              user: AppUserModel.fromSupabaseUser(res.user!),
              needsEmailConfirmation: res.session == null,
              accessToken: res.session?.accessToken,
              refreshToken: res.session?.refreshToken,
            );
          });
    } on AuthException catch (e) {
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
  Future<AppUserModel?> getCurrentUser() async {
    final supabaseUser = _auth.currentUser;
    return supabaseUser == null
        ? null
        : AppUserModel.fromSupabaseUser(supabaseUser);
  }

  @override
  Future<SignInResponseDto> refreshSession() async {
    return _auth.refreshSession().then((res) {
      if (res.user == null || res.session == null) {
        throw CustomException.auth(
          message: 'session refreshed but user, session is null',
          code: ErrorCode.notFound,
        );
      }
      return SignInResponseDto(
        user: AppUserModel.fromSupabaseUser(res.user!),
        accessToken: res.session?.accessToken,
        refreshToken: res.session?.refreshToken,
      );
    });
  }

  @override
  Future<SignInResponseDto> signIn(SignInRequestDto request) async {
    try {
      final res = await _auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );
      if (res.user == null || res.session == null) {
        throw CustomException.auth(
          message: 'log in, but user, session is null',
        );
      }

      return SignInResponseDto(
        user: AppUserModel.fromSupabaseUser(res.user!),
        accessToken: res.session?.accessToken,
        refreshToken: res.session?.refreshToken,
      );
    } on AuthException catch (e) {
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
    } on AuthException catch (e) {
      throw CustomException.auth(
        message: e.message,
        code: ErrorCode.internalServer,
      );
    } catch (e) {
      rethrow;
    }
  }
}
