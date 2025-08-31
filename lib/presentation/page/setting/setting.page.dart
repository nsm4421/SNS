import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';

part 'setting.screen.dart';

@RoutePage()
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting Page"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(SignOutEvent());
            },
            icon: Icon(Icons.login_outlined),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}
