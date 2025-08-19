import 'package:auto_route/auto_route.dart';
import 'package:sns/presentation/page/auth/sign_in/sign_in.page.dart';
import 'package:sns/presentation/page/auth/sign_up/sign_up.page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SignUpRoute.page, path: '/auth/sign-up'),
    AutoRoute(page: SignInRoute.page, path: '/auth/sign-in', initial: true),
  ];
}
