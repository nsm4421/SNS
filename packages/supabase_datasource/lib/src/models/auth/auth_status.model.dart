import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_datasource/src/models/auth/app_user.model.dart';

part 'auth_status.model.freezed.dart';

@freezed
sealed class AuthStatusModel with _$AuthStatusModel {
  const factory AuthStatusModel.signedIn({
    required AppUserModel user,
    String? accessToken,
    String? refreshToken,
  }) = SignedIn;

  const factory AuthStatusModel.signedOut() = SignedOut;

  const factory AuthStatusModel.tokenRefreshed({
    String? accessToken,
    String? refreshToken,
    AppUserModel? user,
  }) = TokenRefreshed;

  const factory AuthStatusModel.userUpdated({
    required AppUserModel user,
  }) = UserUpdated;

  const factory AuthStatusModel.unknown([String? message]) =
      UnknownAuthStatusModel;
}
