import 'dart:async';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/auth/presentation/bloc/authentication/authentication.bloc.dart';

@lazySingleton
class AuthStatusNotifier extends ChangeNotifier {
  late final StreamSubscription _authBlocSubscription;
  final AuthenticationBloc _authBloc;
  late AuthStatus _currentAuthStatus;

  AuthStatusNotifier(this._authBloc) {
    _currentAuthStatus = _authBloc.state.status;
    // _authBloc.authStatusStream이 아니라 _authBloc.stream을 listen해야 함
    // 안 그러면 AuthNotifier와 authStatusStream 시점 차이 때문에 어긋나서 버그남 ㅠ
    _authBlocSubscription = _authBloc.stream.listen((state) {
      if (_currentAuthStatus != state.status) {
        _currentAuthStatus = state.status;
        notifyListeners();
      }
    });
  }

  AuthStatus get currentAuthStatus => _currentAuthStatus;

  bool get isAuth => _currentAuthStatus == AuthStatus.authenticated;

  @override
  void dispose() {
    _authBlocSubscription.cancel();
    super.dispose();
  }
}
