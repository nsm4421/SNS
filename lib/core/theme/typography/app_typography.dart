import 'package:flutter/material.dart';
import 'package:sns/core/theme/color_scheme/app_color.dart';

part 'light_app_typography.dart';

part 'dark_app_typography.dart';

abstract class AppTypography {
  TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  TextStyle get displayLarge => const TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.w700,
    height: 1.10,
    letterSpacing: -0.2,
  );

  TextStyle get displayMedium => const TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -0.15,
  );

  TextStyle get displaySmall => const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.10,
  );

  TextStyle get headlineLarge => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.20,
    letterSpacing: -0.05,
  );

  TextStyle get headlineMedium => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.22,
    letterSpacing: -0.02,
  );

  TextStyle get headlineSmall => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0.0,
  );

  TextStyle get titleLarge => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.30,
    letterSpacing: 0.0,
  );

  TextStyle get titleMedium => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.32,
    letterSpacing: 0.05,
  );

  TextStyle get titleSmall => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.32,
    letterSpacing: 0.05,
  );

  // === Body (본문)

  TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.2,
  );

  TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.50,
    letterSpacing: 0.15,
  );

  TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.10,
  );

  TextStyle get labelLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.20,
    letterSpacing: 0.10,
  );

  TextStyle get labelMedium => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.20,
    letterSpacing: 0.50,
  );

  TextStyle get labelSmall => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: 0.50,
  );
}
