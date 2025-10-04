import 'package:shared/shared.dart';

final class _AppLogger extends LoggerUtil {}

final _logger = _AppLogger().logger;

mixin class AppLoggerMixIn {
  logT(String message, {Object? e, StackTrace? st}) {
    _logger.t(message, error: e, stackTrace: st);
  }

  logE(String message, {Object? e, StackTrace? st}) {
    _logger.e(message, error: e, stackTrace: st);
  }

  logD(String message, {Object? e, StackTrace? st}) {
    _logger.d(message, error: e, stackTrace: st);
  }

  logW(String message, {Object? e, StackTrace? st}) {
    _logger.w(message, error: e, stackTrace: st);
  }

  logF(Failure fail, {Object? e, StackTrace? st}) {
    _logger.fail(fail, error: e, stackTrace: st);
  }
}
