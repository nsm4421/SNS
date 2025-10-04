part of 'sign_up.page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  late final GlobalKey<FormState> _formKey;
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _tappable = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
  }

  _handleSwitchPasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  _handleSwitchPasswordConfirmVisibility() {
    setState(() {
      _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
    });
  }

  String? _handleValidateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return 'type email';
    }
    final reg = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!reg.hasMatch(text)) {
      return 'invalid email address';
    }
    return null;
  }

  String? _handleValidatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return 'type password';
    } else if (text.length < 6) {
      return 'use at least 6 characters';
    }
    return null;
  }

  String? _handleValidatePasswordConfirm(String? text) {
    if (text == null || text.isEmpty) {
      return 'type password confirm';
    } else if (text != _passwordController.text.trim()) {
      return 'passwords are not matched';
    }
    return null;
  }

  _handleSubmit() async {
    setState(() {
      _tappable = false;
    });
    try {
      _formKey.currentState?.save();
      final ok = _formKey.currentState?.validate();
      if (ok == null || !ok) return;
      context.read<AuthBloc>().add(
        AuthEvent.signUpRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    } catch (_, st) {
      debugPrintStack(stackTrace: st);
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _tappable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("SIGN UP")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 회원가입 입력폼
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // 이메일 텍스트 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: TextFormField(
                      validator: _handleValidateEmail,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: 'Email',
                      ),
                    ),
                  ),

                  // 비밀번호 텍스트 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: TextFormField(
                      validator: _handleValidatePassword,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_outlined),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: _handleSwitchPasswordVisibility,
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 비밀번호 확인 텍스트 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: TextFormField(
                      validator: _handleValidatePasswordConfirm,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordConfirmController,
                      obscureText: !_isPasswordConfirmVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_outlined),
                        hintText: 'Password Confirm',
                        suffixIcon: IconButton(
                          onPressed: _handleSwitchPasswordConfirmVisibility,
                          icon: Icon(
                            _isPasswordConfirmVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 로그인 버튼
            GestureDetector(
              onTap: _tappable ? _handleSubmit : null,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _tappable
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "SUBMIT",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
