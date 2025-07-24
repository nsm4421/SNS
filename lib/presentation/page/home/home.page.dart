import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/presentation/bloc/auth/authentication/authentication.bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(SignOutEvent());
            },
            icon: Icon(Icons.login),
          ),
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome')),
    );
  }
}
