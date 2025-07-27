import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'failure.dart';

@lazySingleton
mixin class ResponseResponseWrapperMixIn {
  final _logger = Logger(
    level: Level.error,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  Future<Either<Failure, R>> guardApi<R>(Future<R> Function() action) async {
    try {
      return await action().then(Right.new);
    } catch (e) {
      _logger.e(e);
      return Left(Failure.fromError(e));
    }
  }
}
