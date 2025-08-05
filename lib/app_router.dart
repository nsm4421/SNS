import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/poll/poll.export.dart';
import 'features/auth/auth.export.dart';
import 'features/home/home.export.dart';

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
    GoRoute(
      path: AppRoutes.displayTopics.path,
      builder: (context, state) => const DisplayTopicPage(),
    ),
    GoRoute(
      path: AppRoutes.topicDetail.path,
      builder: (context, state) {
        try {
          final topicId = state.extra as String;
          return TopicDetailPage(topicId);
        } catch (error) {
          return const HomePage();
        }
      },
    ),
  ];
}
