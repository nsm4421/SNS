part of 'sign_up.page.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: SignUpFormFragment(),
            ),
          ],
        ),
      ),
      floatingActionButton: const SignUpSubmitButton(),
    );
  }
}
