import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
mixin class ImageUtilMixIn {
  Future<(int width, int height)> getXFileSize(XFile xFile) async {
    final bytes = await xFile.readAsBytes();
    final decoded = await decodeImageFromList(bytes);
    return (decoded.width, decoded.height);
  }
}
