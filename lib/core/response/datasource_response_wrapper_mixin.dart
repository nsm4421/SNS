import 'dart:async';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constant/error_type.constant.dart';
import 'api_exception.dart';

@lazySingleton
mixin class DataSourceResponseWrapperMixIn {
  Future<R> guardApi<R>(Future<R> Function() action) async {
    try {
      return await action();
    } on ApiException {
      rethrow;
    } on AuthException catch (e) {
      throw ApiException(type: ErrorType.unauthorized, message: e.message);
    } on PostgrestException catch (e) {
      throw ApiException(type: ErrorType.server, message: e.message);
    } on TimeoutException {
      throw const ApiException(
        type: ErrorType.timeout,
        message: 'timeout error occurs',
      );
    } on SocketException {
      throw const ApiException(
        type: ErrorType.network,
        message: 'network connection error occurs',
      );
    } catch (e) {
      throw ApiException(
        type: ErrorType.unknown,
        message: 'unknown error occurs (${e.runtimeType})',
      );
    }
  }
}
