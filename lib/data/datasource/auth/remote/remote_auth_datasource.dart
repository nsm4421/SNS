import 'dart:async';
import 'package:logger/logger.dart';

import 'package:karma/data/model/model.export.dart';
import 'package:karma/core/core.export.dart';
import 'package:supabase/supabase.dart';

part 'remote_auth_datasource_impl.dart';

abstract interface class RemoteAuthDataSource {
  String? get currentUserId;

  Stream<AuthStatusModel> get authStatusStream;

  Future<AuthResponseDto> signUp({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  });

  Future<AuthResponseDto> signIn({
    required String email,
    required String password,
  });

  Future<AppUserModel> getCurrentUser();

  Future<void> signOut();

  Future<AuthResponseDto> restoreSession([String? refreshToken]);
}
