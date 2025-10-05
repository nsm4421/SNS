import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/presentation/provider/auth/auth.bloc.dart';
import 'package:karma/presentation/router/app_router.dart';

abstract class _AuthPageGuard extends AutoRouteGuard {
  final AuthBloc _authBloc;

  _AuthPageGuard(this._authBloc);

  // 로딩이 끝날 때 까지 기다리기
  Future<void> waitUntilResolved() async {
    if (!_authBloc.state.isLoading) return;
    await _authBloc.stream.firstWhere((s) => !s.isLoading);
  }
}

/// 인증되지 않은 경우 로그인 페이지로 라우팅
@lazySingleton
class AuthPageGuard extends _AuthPageGuard {
  AuthPageGuard(super.authBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    await waitUntilResolved();
    if (_authBloc.state.isAuth) {
      resolver.next(true);
    } else {
      router.replaceAll([const SignInRoute()]);
    }
  }
}

/// 인증되어 있으면 홈화면으로 라우팅
@lazySingleton
class UnAuthPageGuard extends _AuthPageGuard {
  UnAuthPageGuard(super.authBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    await waitUntilResolved();
    if (_authBloc.state.isAuth) {
      router.replaceAll([const HomeRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
