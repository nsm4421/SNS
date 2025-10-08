import 'package:logger/logger.dart';
import '../exception/failure.dart';

extension LoggerExtension on Logger {
  void _fail(Failure failure, {Object? error, StackTrace? stackTrace}) {
    e(
      "code:${failure.code.name}\nmessage:${failure.message}${failure.tag ?? '\ntag:${failure.tag}'}",
      error: error,
      stackTrace: stackTrace,
    );
  }

  logT(String message, {Object? e, StackTrace? st}) {
    this.t(message, error: e, stackTrace: st);
  }

  logE(String message, {Object? e, StackTrace? st}) {
    this.e(message, error: e, stackTrace: st);
  }

  logD(String message, {Object? e, StackTrace? st}) {
    this.d(message, error: e, stackTrace: st);
  }

  logW(String message, {Object? e, StackTrace? st}) {
    this.w(message, error: e, stackTrace: st);
  }

  logF(Failure fail, {Object? e, StackTrace? st}) {
    this._fail(fail, error: e, stackTrace: st);
  }
}
