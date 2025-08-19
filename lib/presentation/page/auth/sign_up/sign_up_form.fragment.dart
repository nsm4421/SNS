part of 'sign_up.page.dart';

class SignUpFormFragment extends StatefulWidget {
  const SignUpFormFragment({super.key});

  @override
  State<SignUpFormFragment> createState() => _SignUpFormFragmentState();
}

class _SignUpFormFragmentState extends State<SignUpFormFragment> {
  static const int _minPasswordLength = 6;
  static const int _minUsernameLength = 2;

  late final TextEditingController _emailTec;
  late final TextEditingController _passwordTec;
  late final TextEditingController _passwordConfirmTec;
  late final TextEditingController _usernameTec;

  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  late final FocusNode _usernameFocus;

  late bool _isPasswordVisible;
  late bool _isPasswordConfirmVisible;

  @override
  void initState() {
    super.initState();
    _emailTec = TextEditingController();
    _passwordTec = TextEditingController();
    _passwordConfirmTec = TextEditingController();
    _usernameTec = TextEditingController();

    _emailFocus = FocusNode()..addListener(_handleEmailFocus);
    _passwordFocus = FocusNode()..addListener(_handlePasswordFocus);
    _usernameFocus = FocusNode()..addListener(_handleUsernameFocus);

    _isPasswordVisible = false;
    _isPasswordConfirmVisible = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailTec.dispose();
    _passwordTec.dispose();
    _passwordConfirmTec.dispose();
    _usernameTec.dispose();

    _emailFocus
      ..removeListener(_handleEmailFocus)
      ..dispose();
    _passwordFocus
      ..removeListener(_handlePasswordFocus)
      ..dispose();
    _usernameFocus
      ..removeListener(_handleUsernameFocus)
      ..dispose();
  }

  _handleSwitchIsPasswordVisible() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  _handleSwitchIsPasswordConfirmVisible() {
    setState(() {
      _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
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
    } else if (text.length < _minPasswordLength) {
      return '비밀번호는 최소 $_minPasswordLength자를 입력해주세요';
    }
    return null;
  }

  String? _handleValidatePasswordConfirm(String? text) {
    if (text == null || text.isEmpty) {
      return '비밀번호를 다시 입력하세요';
    } else if (text != _passwordTec.text.trim()) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  String? _handleValidateUsername(String? text) {
    if (text == null || text.isEmpty) {
      return '유저명을 입력하세요';
    } else if (text.length < _minUsernameLength) {
      return '유저명은 최소 $_minUsernameLength글자로 입력해주세요';
    }
    return null;
  }

  _handleEmailFocus() {
    if (_emailFocus.hasFocus) return;
    context.read<SignUpCubit>().updateEmail(_emailTec.text.trim());
  }

  _handlePasswordFocus() {
    if (_passwordFocus.hasFocus) return;
    context.read<SignUpCubit>().updatePassword(_passwordTec.text.trim());
  }

  _handleUsernameFocus() {
    if (_usernameFocus.hasFocus) return;
    context.read<SignUpCubit>().updateUsername(_usernameTec.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTec,
            focusNode: _emailFocus,
            validator: _handleValidateEmail,
            decoration: const InputDecoration(
              icon: Icon(Icons.email_outlined),
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordTec,
            focusNode: _passwordFocus,
            validator: _handleValidatePassword,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              icon: const Icon(Icons.password_outlined),
              hintText: 'Password',
              helperText: '최소 $_minPasswordLength자로 비밀번호를 입력해주세요',
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
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordConfirmTec,
            validator: _handleValidatePasswordConfirm,
            obscureText: !_isPasswordConfirmVisible,
            decoration: InputDecoration(
              icon: const Icon(Icons.password_outlined),
              hintText: 'Password Confirm',
              helperText: '비밀번호를 다시 입력해주세요',
              suffixIcon: IconButton(
                onPressed: _handleSwitchIsPasswordConfirmVisible,
                icon: Icon(
                  _isPasswordConfirmVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _usernameTec,
            focusNode: _usernameFocus,
            validator: _handleValidateUsername,
            decoration: const InputDecoration(
              icon: Icon(Icons.account_box_outlined),
              hintText: 'Username',
              helperText: '최소 $_minUsernameLength자로 유저명을 입력해주세요',
            ),
          ),
        ],
      ),
    );
  }
}
