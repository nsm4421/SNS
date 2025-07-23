import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/features/auth/presentation/bloc/sign_in/sign_in.cubit.dart';

class FormFragment extends StatefulWidget {
  const FormFragment({super.key});

  @override
  State<FormFragment> createState() => _FormFragmentState();
}

class _FormFragmentState extends State<FormFragment> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()..addListener(_handleEmail);
    _passwordController = TextEditingController()..addListener(_handlePassword);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController
      ..removeListener(_handleEmail)
      ..dispose();
    _passwordController
      ..removeListener(_handlePassword)
      ..dispose();
  }

  void _handleEmail() {
    context.read<SignInCubit>().handleData(email: _emailController.text.trim());
  }

  void _handlePassword() {
    context.read<SignInCubit>().handleData(
      password: _passwordController.text.trim(),
    );
  }

  String? _validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return 'email is not given';
    }
    return null;
  }

  String? _validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return 'password is not given';
    } else if (text.length < 6) {
      return 'password is too short (min length 6)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignInCubit>().formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: _emailController,
              validator: _validateEmail,
              decoration: const InputDecoration(
                hintText: 'example@google.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: _passwordController,
              validator: _validatePassword,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'press password',
                prefixIcon: Icon(Icons.password_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
