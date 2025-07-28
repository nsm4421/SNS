import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_error.dart';

@lazySingleton
mixin class RepositoryResponseWrapperMixIn {
  Future<Either<ApiError, R>> guardApi<R>(
    Future<R> Function() action, {
    Logger? logger,
  }) async {
    try {
      return await action().then(Right.new);
    } on ApiException catch (e) {
      logger?.e(e);
      rethrow;
    } on AuthException catch (e) {
      logger?.e(e);
      final status = int.tryParse((e.statusCode ?? '')) ?? 0;
      final type = switch (status) {
        401 => ApiErrorType.unauthorized,
        403 => ApiErrorType.forbidden,
        408 => ApiErrorType.timeout,
        400 => ApiErrorType.validation,
        >= 500 => ApiErrorType.server,
        _ => ApiErrorType.unknown,
      };
      return Left(ApiError(type: type, message: e.message, statusCode: status));
    } on PostgrestException catch (e) {
      final code = int.tryParse(e.code ?? '');
      ApiErrorType type;
      if (code != null) {
        if (code >= 500) {
          type = ApiErrorType.server;
        } else {
          switch (code) {
            case 400:
              type = ApiErrorType.validation;
              break;
            case 401:
              type = ApiErrorType.unauthorized;
              break;
            case 403:
              type = ApiErrorType.forbidden;
              break;
            case 404:
              type = ApiErrorType.notFound;
              break;
            case 408:
              type = ApiErrorType.timeout;
              break;
            case 409:
              type = ApiErrorType.conflict;
              break;
            default:
              type = ApiErrorType.unknown;
          }
        }
      } else {
        type = ApiErrorType.unknown;
      }
      return Left(ApiError(type: type, message: e.message, statusCode: code));
    } on StorageException catch (e) {
      logger?.e(e);
      return Left(
        ApiError(
          type: ApiErrorType.storage,
          message: e.message,
          statusCode: int.tryParse(e.statusCode ?? ''),
        ),
      );
    } catch (e, _) {
      logger?.e(e);
      return Left(ApiError(type: ApiErrorType.unknown, message: e.toString()));
    }
  }
}
