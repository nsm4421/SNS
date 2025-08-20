part of 'sign_in.page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24),
              child: SignInFormFragment(),
            ),

            Padding(
              padding: EdgeInsets.only(top: 16, left: 24, right: 24),
              child: SignInButtonsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
