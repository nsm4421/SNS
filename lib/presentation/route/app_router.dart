import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/presentation/bloc/auth/authentication/authentication.bloc.dart';

import '../page/auth/sign_in/sign_in.page.dart';
import '../page/auth/sign_up/sign_up.page.dart';
import '../page/home/home.page.dart';

import 'app_routes.dart';
import 'auth_status_notifier.dart';

@lazySingleton
class AppRouter with AppLogger {
  final AuthenticationBloc _authBloc;

  AppRouter(this._authBloc);

  @lazySingleton
  GoRouter get routeConfig => GoRouter(
    initialLocation: AppRoutes.values.firstWhere((e) => e.isEntry).path,
    refreshListenable: AuthStatusNotifier(_authBloc),
    redirect: (context, state) {
      final isAuth = _authBloc.state.status == AuthStatus.authenticated;
      logger.t('[AppRouter] redirection called with auth status: $isAuth');

      final isGoingToAuth = state.matchedLocation.startsWith(
        AppRoutes.authPrefix,
      );

      if (!isAuth && !isGoingToAuth) {
        logger.t('[AppRouter]redirected to sign in ${_authBloc.state.status}');
        return AppRoutes.signIn.path;
      } else if (isAuth && isGoingToAuth) {
        logger.t('[AppRouter]redirected to home ${_authBloc.state.status}');
        return AppRoutes.home.path;
      } else {
        logger.t('[AppRouter] staying on ${state.matchedLocation}');
        return null;
      }
    },
    routes: [..._authRoutes, ..._homeRoutes],
  );

  Iterable<GoRoute> get _authRoutes => [
    GoRoute(
      path: AppRoutes.signIn.path,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: AppRoutes.signUp.path,
      builder: (context, state) => const SignUpPage(),
    ),
  ];

  Iterable<GoRoute> get _homeRoutes => [
    GoRoute(
      path: AppRoutes.home.path,
      builder: (context, state) => const HomePage(),
    ),
  ];
}
