import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:karma/data/model/auth/app_user.model.dart';

part 'auth_status.model.freezed.dart';

@freezed
sealed class AuthStatusModel with _$AuthStatusModel {
  const factory AuthStatusModel.signedIn({
    String? accessToken,
    String? refreshToken,
    required AppUserModel user,
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
