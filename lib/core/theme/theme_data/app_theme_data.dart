import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../color_scheme/app_color.dart';
import '../typography/app_typography.dart';

part 'light_app_theme_data.dart';

part 'dark_app_theme_data.dart';

abstract class AppThemeData {
  AppColor get appColor;

  ColorScheme get scheme;

  TextTheme get textTheme ;

  bool get isDark;

  ThemeData get themeData;
}
