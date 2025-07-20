class UserEntity {

  final String email;
  final String password;
  final String username;

  static const int _minPasswordLength = 6;

  UserEntity({
    required this.email,
    required this.password,
    required this.username,
  }) {
    if (email.trim().isEmpty || !email.contains('@')) {
      throw const FormatException('invalid email');
    } else if (password.trim().isEmpty ||
        password.trim().length < _minPasswordLength) {
      throw const FormatException('invalid password');
    } else if (username.trim().isEmpty) {
      throw const FormatException('invalid username');
    }
  }
}
