import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/features/auth/presentation/screens/sign_in/sign_in.page.dart';
import 'package:sns/features/auth/presentation/screens/sign_up/sign_up.page.dart';

part 'app_router.gr.dart';

part 'app_routes.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SignInRoute.page,
      path: AppRoutes.signIn.path,
      initial: true,
    ),
    AutoRoute(page: SignUpRoute.page, path: AppRoutes.signUp.path),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
