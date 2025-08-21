import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';
import 'package:sns/presentation/router/app_router.dart';

@lazySingleton
class AuthRouteGuard extends AutoRouteGuard {
  AuthRouteGuard(this._authBloc);

  late final AuthenticationBloc _authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isInAuthRoute = router.current.path.startsWith('/auth');
    final isAuth = _authBloc.state.status == AuthStatus.authenticated;

    bool continueNavigation = true;
    if (isAuth && isInAuthRoute) {
      continueNavigation =
          await router.replace<bool>(const HomeRoute()) ?? false;
    } else if (!isAuth && !isInAuthRoute) {
      continueNavigation =
          await router.replace<bool>(const SignInRoute()) ?? false;
    }

    resolver.next(continueNavigation);
  }
}
