import 'dart:async';

import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/auth/remote/dto/sign_in.dto.dart';
import 'package:supabase_datasource/src/auth/remote/dto/sign_up.dto.dart';
import 'package:supabase_datasource/src/models/auth/app_user.model.dart';
import 'package:supabase_datasource/src/models/auth/auth_status.model.dart';
import 'package:shared/shared.dart';

part 'auth_datasource_impl.dart';

abstract interface class AuthDataSource {
  Stream<AuthStatusModel> get authStatusStream;

  Future<SignUpResponseDto> signUp(
    SignUpRequestDto request,
  );

  Future<SignInResponseDto> signIn(
    SignInRequestDto request,
  );

  Future<AppUserModel> getCurrentUser();

  Future<void> signOut();

  Future<SignInResponseDto> refreshSession();
}
