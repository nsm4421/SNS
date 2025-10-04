import 'package:logger/logger.dart';
import 'package:shared/shared.dart';

abstract class LoggerUtil {
  late final Logger _logger;

  LoggerUtil() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        // Number of method calls to be displayed
        errorMethodCount: 8,
        // Number of method calls if stacktrace is provided
        lineLength: 120,
        // Width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  Logger get logger => _logger;
}

extension LoggerExtension on Logger {
  void fail(Failure failure, {Object? error, StackTrace? stackTrace}) {
    e(
      "code:${failure.code.name}\nmessage:${failure.message}${failure.tag ?? '\ntag:${failure.tag}'}",
      error: error,
      stackTrace: stackTrace,
    );
  }
}
