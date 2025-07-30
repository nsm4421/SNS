import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/features/auth/presentation/bloc/authentication/authentication.bloc.dart';
import 'package:sns/features/poll/presentation/page/create_topic/create_topic.page.dart';

import 'features/auth/presentation/page/sign_in/sign_in.page.dart';
import 'features/auth/presentation/page/sign_up/sign_up.page.dart';
import 'features/home/presentation/page/home.page.dart';

import 'core/constant/app_routes.constant.dart';
import 'features/auth/presentation/route/auth_status_notifier.dart';

@lazySingleton
class AppRouter {
  final AuthenticationBloc _authBloc;

  AppRouter(this._authBloc);

  @lazySingleton
  GoRouter get routeConfig => GoRouter(
    initialLocation: AppRoutes.values.firstWhere((e) => e.isEntry).path,
    refreshListenable: AuthStatusNotifier(_authBloc),
    redirect: (context, state) {
      final isAuth = _authBloc.state.status == AuthStatus.authenticated;

      final isGoingToAuth = state.matchedLocation.startsWith(
        AppRoutes.authPrefix,
      );

      if (!isAuth && !isGoingToAuth) {
        return AppRoutes.signIn.path;
      } else if (isAuth && isGoingToAuth) {
        return AppRoutes.home.path;
      } else {
        return null;
      }
    },
    routes: [..._authRoutes, ..._homeRoutes, ..._topicRoutes],
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

  Iterable<GoRoute> get _topicRoutes => [
    GoRoute(
      path: AppRoutes.createTopic.path,
      builder: (context, state) => const CreateTopicPage(),
    ),
  ];
}
