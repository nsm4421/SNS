import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/view/component/sign_out_icon_button.widget.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        actions: [
          SignOutIconButtonWidget(),
        ],
      ),
    );
  }
}
