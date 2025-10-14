import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/presentation/component/user_avatar_widget.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart';

part 's_setting_tab.dart';

@RoutePage()
class SettingTabPage extends StatelessWidget {
  const SettingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingTabScreen();
  }
}
