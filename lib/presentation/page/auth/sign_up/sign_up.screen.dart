import 'package:flutter/material.dart';
import 'form.fragment.dart';
import 'submit_button.widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Sign Up')),
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
            SubmitButtonWidget(),
          ],
        ),
      ),
    );
  }
}
