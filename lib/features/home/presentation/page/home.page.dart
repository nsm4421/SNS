import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sns/core/constant/app_routes.constant.dart';
import 'package:sns/features/auth/presentation/bloc/authentication/authentication.bloc.dart';
import 'package:sns/features/poll/presentation/page/display_topics/display_topics.page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DisplayTopicPage();
  }
}
