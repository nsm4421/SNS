import 'package:flutter/material.dart';

part 'app_palette.dart';
part 'light_app_color.dart';
part 'dark_app_color.dart';

abstract class AppColor {
  ColorScheme get scheme;

  bool get isDark;
}

