import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
sealed class AuthFailure with _$AuthFailure {
  const factory AuthFailure.network([String? message]) = Network;

  const factory AuthFailure.conflictEmail([String? message]) = ConflictEmail;

  const factory AuthFailure.invalidCredentials([String? message]) =
      InvalidCreds;

  const factory AuthFailure.rateLimited([String? message]) = RateLimited;

  const factory AuthFailure.server([String? message]) = ServerFailure;

  const factory AuthFailure.unknown([String? message]) = UnknownFailure;
}
