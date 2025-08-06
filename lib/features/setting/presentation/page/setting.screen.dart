import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/features/auth/auth.export.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SETTING"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(SignOutEvent());
            },
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'SIGN OUT',
          ),
        ],
      ),
    );
  }
}
