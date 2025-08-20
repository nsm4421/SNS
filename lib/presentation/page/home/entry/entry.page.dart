import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';

@RoutePage()
class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("HOME"),
    actions: [IconButton(onPressed: ()async{

      context.read<AuthenticationBloc>()..add(SignOutEvent());
    }, icon: Icon(Icons.logout_outlined))],
    ));
  }
}
