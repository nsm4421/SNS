import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:alarm/presentation/view/index.page.dart' show IndexPage;

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: IndexRoute.page, path: '/', initial: true),
  ];
}
