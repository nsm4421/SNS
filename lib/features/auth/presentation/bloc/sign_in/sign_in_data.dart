part of 'sign_in.cubit.dart';

@CopyWith()
class SignInData {
  final String email;
  final String password;

  SignInData({this.email = '', this.password = ''});
}
