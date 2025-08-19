part of 'sign_up.cubit.dart';

@CopyWith(copyWithNull: true)
class SignUpData {
  final String email;
  final String password;
  final String username;
  final File? profileImage;

  SignUpData({
    this.email = '',
    this.password = '',
    this.username = '',
    this.profileImage,
  });
}
