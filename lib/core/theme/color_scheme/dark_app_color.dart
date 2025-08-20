part of 'app_color.dart';

class DarkAppColor extends LightAppColor {
  static final ColorScheme _cached =
      ColorScheme.fromSeed(
        seedColor: AppPalette.brandGreen,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppPalette.brandGreen,
        secondary: AppPalette.brandGreenBright,
        tertiary: AppPalette.brandGreenDark,
        surface: AppPalette.brandSurfaceDark,
        onSurface: Colors.white,
        surfaceContainerHighest: AppPalette.neutral12,
        onSurfaceVariant: AppPalette.textMutedDark,
        outline: AppPalette.brandOutlineDark,
        error: AppPalette.error,
        onError: Colors.white,
        inverseSurface: AppPalette.brandWhite,
        onInverseSurface: const Color(0xFF111111),
        inversePrimary: AppPalette.brandGreenBright,
      );

  @override
  ColorScheme get scheme => _cached;

  @override
  bool get isDark => true;
}
