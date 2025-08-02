import 'package:sns/core/constant/api_error_type.constant.dart';

import 'api_error.dart';
import 'failure.dart';

mixin class ApiErrorToFailureMapperMixIn {
  Failure handleFailure(ApiError err, {String? message}) {
    switch (err.type) {
      case ApiErrorType.unauthorized:
        return Failure.unAuthorized(message);
      case ApiErrorType.validation:
        return Failure.validation(message);
      case ApiErrorType.network:
        return Failure.network(message);
      case ApiErrorType.server:
        return Failure.server(message);
      default:
        return Failure.unknown(message);
    }
  }
}
