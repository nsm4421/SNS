import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/presentation/page/auth/sign_in/sign_in.page.dart'
    show SignInPage;
import 'package:sns/presentation/page/auth/sign_up/sign_up.page.dart'
    show SignUpPage;
import 'package:sns/presentation/page/feed/create/create_feed.page.dart';
import 'package:sns/presentation/page/feed/display/display_feed.page.dart';
import 'package:sns/presentation/page/home/home.page.dart' show HomePage;
import 'package:sns/presentation/page/home/splash.page.dart' show SplashPage;
import 'package:sns/presentation/page/reels/create/create_reels.page.dart'
    show CreateReelsPage;
import 'package:sns/presentation/page/reels/display/display_reels.page.dart'
    show DisplayReelsPage;
import 'package:sns/presentation/page/setting/setting.page.dart'
    show SettingPage;

import 'package:sns/presentation/router/auth_route_guard.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final AuthRouteGuard _authRouteGuard;

  AppRouter(this._authRouteGuard);

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: '/', initial: true),
    AutoRoute(page: SignUpRoute.page, path: '/auth/sign-up'),
    AutoRoute(page: SignInRoute.page, path: '/auth/sign-in'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      guards: [_authRouteGuard],
      children: [
        AutoRoute(
          page: DisplayFeedRoute.page,
          path: 'feed/display',
          initial: true,
        ),
        AutoRoute(page: DisplayReelsRoute.page, path: 'reels/display'),
        AutoRoute(page: SettingRoute.page, path: 'setting'),
      ],
    ),
    AutoRoute(page: CreateFeedRoute.page, path: '/feed/create'),
    AutoRoute(page: CreateReelsRoute.page, path: '/reels/create'),
  ];
}
