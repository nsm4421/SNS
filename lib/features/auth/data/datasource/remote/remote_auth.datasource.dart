part of 'remote_auth.datasource_impl.dart';

abstract interface class RemoteAuthDataSource {
  Stream<AuthState> get authStateStream;

  Future<AuthUserModel> getAuthUser();

  Future<String?> signUp(SignUpRequestModel dto);

  Future<(String accessToken, String refreshToken)> signIn({
    required String email,
    required String password,
  });

  Future<String?> editProfile(EditProfileRequestModel dto);

  Future<void> signOut();

  Future<Session?> restoreSession(String refreshToken);
}
