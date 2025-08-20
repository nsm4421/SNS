import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/presentation/page/auth/sign_in/sign_in.page.dart'
    show SignInPage;
import 'package:sns/presentation/page/auth/sign_up/sign_up.page.dart'
    show SignUpPage;
import 'package:sns/presentation/page/home/entry/entry.page.dart'
    show EntryPage;
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
    AutoRoute(page: SignUpRoute.page, path: '/auth/sign-up'),
    AutoRoute(page: SignInRoute.page, path: '/auth/sign-in', initial: true),
    AutoRoute(page: EntryRoute.page, path: '/', guards: [_authRouteGuard]),
  ];
}
