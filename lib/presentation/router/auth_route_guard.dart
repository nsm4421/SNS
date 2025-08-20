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
    if (_authBloc.state.status == AuthStatus.authenticated) {
      resolver.next(true);
    } else {
      router.replace<bool>(const SignInRoute()).then((ok) {
        resolver.next(ok == true);
      });
    }
  }
}
