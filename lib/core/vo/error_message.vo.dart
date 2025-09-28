enum AuthErrorMessage {
  gettingCurrentUserFail('getting current user fails'),
  duplicatedEmail('duplicated email'),
  invalidCredentials('invalid credentials');

  final String message;

  const AuthErrorMessage(this.message);
}
