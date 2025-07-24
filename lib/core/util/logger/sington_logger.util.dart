import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
mixin class AppLogger {
  final _logger = Logger(
    level: Level.trace,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  Logger get logger => _logger;
}
