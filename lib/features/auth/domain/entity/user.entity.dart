class UserEntity {
  final String id;
  final String email;
  final String username;

  UserEntity({required this.id, required this.email, required this.username}) {
    if (id.trim().isEmpty) {
      throw const FormatException('invalid id');
    } else if (email.trim().isEmpty || !email.contains('@')) {
      throw const FormatException('invalid email');
    } else if (username.trim().isEmpty) {
      throw const FormatException('invalid username');
    }
  }
}
