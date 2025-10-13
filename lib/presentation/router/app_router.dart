import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/presentation/router/auth_guard.dart';
import 'package:karma/presentation/view/auth/sign_in/sign_in.page.dart';
import 'package:karma/presentation/view/auth/sign_up/sign_up.page.dart';
import 'package:karma/presentation/view/entry/chat/chat_tab.page.dart';
import 'package:karma/presentation/view/entry/p_entry.dart';
import 'package:karma/presentation/view/entry/feed/create_post/p_create_post.dart';
import 'package:karma/presentation/view/entry/feed/p_feed_tab.dart';
import 'package:karma/presentation/view/entry/group/group_tab.page.dart';
import 'package:karma/presentation/view/entry/home/home_tab.page.dart';
import 'package:karma/presentation/view/entry/notification/notification_tab.page.dart';
import 'package:karma/presentation/view/entry/setting/setting_tab.page.dart';
import 'package:karma/presentation/view/splash/p_splash.dart';

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
  List<AutoRoute> get routes => [
    _splashRoute,
    ..._authRoutes,
    _entryRoute,
    AutoRoute(page: CreatePostRoute.page, path: '/feed/create'),
  ];

  AutoRoute get _splashRoute => AutoRoute(
    page: SplashRoute.page,
    path: '/splash',
    guards: [_unAuthPageGuard],
    initial: true,
  );

  List<AutoRoute> get _authRoutes => [
    AutoRoute(
      page: SignInRoute.page, // 로그인
      path: '/auth/sign-in',
    ),
    AutoRoute(
      page: SignUpRoute.page, // 회원가입
      path: '/auth/sign-up',
      guards: [_unAuthPageGuard],
    ),
  ];

  AutoRoute get _entryRoute => AutoRoute(
    page: EntryRoute.page,
    path: '/entry',
    guards: [_authPageGuard],
    children: [
      AutoRoute(page: HomeTabRoute.page, path: 'home', initial: true),
      AutoRoute(page: FeedTabRoute.page, path: 'feed'),
      AutoRoute(page: GroupTabRoute.page, path: 'group'),
      AutoRoute(page: ChatTabRoute.page, path: 'chat'),
      AutoRoute(page: NotificationTabRoute.page, path: 'notification'),
      AutoRoute(page: SettingTabRoute.page, path: 'setting'),
    ],
  );
}
