Map<String, dynamic> mockUserJson({
  String id = 'user_1',
  String email = 'me@example.com',
}) => {
  'id': id,
  'email': email,
  'app_metadata': <String, dynamic>{},
  'user_metadata': const {'username': 'karma'},
  'aud': 'authenticated',
  'created_at': DateTime(2024, 1, 1).toIso8601String(),
};

Map<String, dynamic> mockSessionJson({
  String accessToken = 'access',
  String refreshToken = 'refresh',
}) => {
  'access_token': accessToken,
  'refresh_token': refreshToken,
  'token_type': 'bearer',
  'user': mockUserJson(),
  'expires_in': 3600,
  'expires_at': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
};
