import 'dart:io';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

extension FileExtension on File {
  String get filename => basename(this.path);

  String? get mimeType => lookupMimeType(this.path);
}
