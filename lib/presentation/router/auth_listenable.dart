import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';

@lazySingleton
class AuthListenable extends ChangeNotifier {
  AuthListenable(AuthenticationBloc authBloc) {
    _streamSubscription = authBloc.authStatusStream.listen((status) {
      notifyListeners();
    });
  }

  late final StreamSubscription _streamSubscription;

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
