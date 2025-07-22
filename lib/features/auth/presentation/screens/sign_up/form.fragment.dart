import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/features/auth/presentation/bloc/sign_up/sign_up.cubit.dart';

class FormFragment extends StatefulWidget {
  const FormFragment({super.key});

  @override
  State<FormFragment> createState() => _FormFragmentState();
}

class _FormFragmentState extends State<FormFragment> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()..addListener(_handleEmail);
    _passwordController = TextEditingController()..addListener(_handlePassword);
    _passwordConfirmController = TextEditingController();
    _usernameController = TextEditingController()..addListener(_handleUsername);
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
    _passwordConfirmController.dispose();
    _usernameController
      ..removeListener(_handleUsername)
      ..dispose();
  }

  void _handleEmail() {
    context.read<SignUpCubit>().handleData(email: _emailController.text.trim());
  }

  void _handlePassword() {
    context.read<SignUpCubit>().handleData(
      password: _passwordController.text.trim(),
    );
  }

  void _handleUsername() {
    context.read<SignUpCubit>().handleData(
      username: _usernameController.text.trim(),
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

  String? _validatePasswordConfirm(String? text) {
    if (text != _passwordController.text) {
      return 'password is not matched';
    }
    return null;
  }

  String? _validateUsername(String? text) {
    if (text == null || text.isEmpty) {
      return 'username not given';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().formKey,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: _passwordConfirmController,
              validator: _validatePasswordConfirm,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'press password again',
                prefixIcon: Icon(Icons.password_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              controller: _usernameController,
              validator: _validateUsername,
              decoration: const InputDecoration(
                hintText: 'press username',
                prefixIcon: Icon(Icons.face),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
