import 'package:shared/shared.dart';

class Failure {
  final String message;
  final ErrorCode code;
  final String? tag;

  const Failure(this.message, {this.code = ErrorCode.unKnown, this.tag});

  factory Failure.fromObj(Object obj) {
    if (obj is CustomException) {
      return Failure(obj.message, code: obj.code, tag: obj.tag);
    }
    return const Failure('unknown');
  }

  Failure copyWith(String message) {
    return Failure(message, code: this.code, tag: this.tag);
  }
}
