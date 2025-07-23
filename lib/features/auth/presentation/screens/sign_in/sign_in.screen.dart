import 'package:flutter/material.dart';
import 'form.fragment.dart';
import 'buttons.widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Sign In')),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: FormFragment(),
                ),
              ),
            ),
            ButtonsWidget()
          ],
        ),
      ),
    );
  }
}
