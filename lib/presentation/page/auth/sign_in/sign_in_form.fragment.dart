part of 'sign_in.page.dart';

class SignInFormFragment extends StatefulWidget {
  const SignInFormFragment({super.key});

  @override
  State<SignInFormFragment> createState() => _SignInFormFragmentState();
}

class _SignInFormFragmentState extends State<SignInFormFragment> {
  late final TextEditingController _emailTec;
  late final TextEditingController _passwordTec;

  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;

  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _emailTec = TextEditingController();
    _passwordTec = TextEditingController();
    _emailFocus = FocusNode()..addListener(_handleEmailFocus);
    _passwordFocus = FocusNode()..addListener(_handlePasswordFocus);
    _isPasswordVisible = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailTec.dispose();
    _passwordTec.dispose();
    _emailFocus
      ..removeListener(_handleEmailFocus)
      ..dispose();
    _passwordFocus
      ..removeListener(_handlePasswordFocus)
      ..dispose();
  }

  _handleSwitchIsPasswordVisible() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  String? _handleValidateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return '이메일을 입력하세요';
    } else if (!text.isEmail) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  String? _handleValidatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return '비밀번호를 입력하세요';
    }
    return null;
  }

  _handleEmailFocus() {
    if (_emailFocus.hasFocus) return;
    context.read<SignInCubit>().updateEmail(_emailTec.text.trim());
  }

  _handlePasswordFocus() {
    if (_passwordFocus.hasFocus) return;
    context.read<SignInCubit>().updatePassword(_passwordTec.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignInCubit>().formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTec,
            focusNode: _emailFocus,
            validator: _handleValidateEmail,
            decoration: const InputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordTec,
            focusNode: _passwordFocus,
            obscureText: !_isPasswordVisible,
            validator: _handleValidatePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                onPressed: _handleSwitchIsPasswordVisible,
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
