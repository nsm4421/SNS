import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart';

/// 인증되지 않은 경우 로그인 페이지로 라우팅
@lazySingleton
class AuthPageGuard extends AutoRouteGuard {
  AuthPageGuard(this._authBloc);

  final AuthBloc _authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuth = _authBloc.currentUser != null;
    if (isAuth) {
      resolver.next(true);
    } else {
      router.replaceAll([const SignInRoute()]);
    }
  }
}

/// 인증되어 있으면 홈화면으로 라우팅
@lazySingleton
class UnAuthPageGuard extends AutoRouteGuard {
  UnAuthPageGuard(this._authBloc);

  final AuthBloc _authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuth = _authBloc.currentUser != null;
    if (isAuth) {
      router.replaceAll([const HomeRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
