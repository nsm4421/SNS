part of 'sign_in.cubit.dart';

@CopyWith(copyWithNull: true)
class SignInData {
  final String email;
  final String password;

  SignInData({this.email = '', this.password = ''});
}
