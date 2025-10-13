part of 'p_sign_in.dart';

class _SignInScreen extends StatefulWidget {
  const _SignInScreen({super.key});

  @override
  State<_SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<_SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  bool _tappable = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _handleSwitchVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  _handlePushToSignUpPage() async {
    await context.router.replace(const SignUpRoute());
  }

  _handleSubmit() async {
    setState(() {
      _tappable = false;
    });
    try {
      debugPrint('sign in button clicked');
      context.read<AuthBloc>().add(
        AuthEvent.signInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    } catch (_, st) {
      debugPrintStack(stackTrace: st);
      await Future.delayed(const Duration(milliseconds: 800));
    } finally {
      setState(() {
        _tappable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("SIGN IN")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 이메일 텍스트 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextFormField(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_outlined),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: _handleSwitchVisibility,
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
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

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(indent: 24, endIndent: 24),
            ),

            // 회원가입 페이지 라우팅
            GestureDetector(
              onTap: _handlePushToSignUpPage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create New Account",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
