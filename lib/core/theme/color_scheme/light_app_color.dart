part of 'app_color.dart';

class LightAppColor extends AppColor {
  static final ColorScheme _cached =
      ColorScheme.fromSeed(
        seedColor: AppPalette.brandGreen,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppPalette.brandGreen,
        secondary: AppPalette.brandGreenDark,
        tertiary: AppPalette.brandGreenBright,
        surface: AppPalette.brandSurfaceLight,
        onSurface: const Color(0xFF111111),
        surfaceContainerHighest: AppPalette.neutral90,
        onSurfaceVariant: const Color(0xFF3F4145),
        outline: AppPalette.brandOutlineLight,
        error: AppPalette.error,
        onError: Colors.white,
        inverseSurface: AppPalette.brandBlack,
        onInverseSurface: Colors.white,
        inversePrimary: AppPalette.brandGreenDark,
      );

  @override
  ColorScheme get scheme => _cached;

  @override
  bool get isDark => false;
}
