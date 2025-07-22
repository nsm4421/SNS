part of 'sign_up.cubit.dart';

@CopyWith()
class SignUpData {
  final String email;
  final String password;
  final String username;

  SignUpData({this.email = '', this.password = '', this.username = ''});
}
