import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/presentation/router/auth_guard.dart';
import 'package:karma/presentation/view/auth/sign_in/sign_in.page.dart'
    show SignInPage;
import 'package:karma/presentation/view/auth/sign_up/sign_up.page.dart'
    show SignUpPage;
import 'package:karma/presentation/view/chat/display/display_chats.page.dart'
    show DisplayChatsPage;
import 'package:karma/presentation/view/home/home.page.dart' show HomePage;
import 'package:karma/presentation/view/notification/notification.page.dart';
import 'package:karma/presentation/view/setting/setting.page.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this._authPageGuard, this._unAuthPageGuard);

  final AuthPageGuard _authPageGuard;
  final UnAuthPageGuard _unAuthPageGuard;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [..._authRoutes, _homeRoute];

  List<AutoRoute> get _authRoutes => [
    AutoRoute(
      page: SignInRoute.page, // 로그인
      path: '/auth/sign-in',
      guards: [_unAuthPageGuard],
      initial: true,
    ),
    AutoRoute(
      page: SignUpRoute.page, // 회원가입
      path: '/auth/sign-up',
      guards: [_unAuthPageGuard],
    ),
  ];

  AutoRoute get _homeRoute => AutoRoute(
    page: HomeRoute.page,
    path: '/home',
    guards: [_authPageGuard],
    children: [
      AutoRoute(
        page: DisplayChatsRoute.page,
        path: 'display-chats',
        initial: true,
      ),
      AutoRoute(page: NotificationRoute.page, path: 'notification'),
      AutoRoute(page: SettingRoute.page, path: 'setting'),
    ],
  );
}
