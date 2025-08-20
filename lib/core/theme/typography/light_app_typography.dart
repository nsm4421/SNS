part of 'app_typography.dart';

class LightTypography extends AppTypography {
  final AppColor _colorScheme;

  LightTypography(LightAppColor this._colorScheme);

  @override
  TextStyle get displayLarge =>
      super.displayLarge.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get displayMedium =>
      super.displayMedium.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get displaySmall =>
      super.displaySmall.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get headlineLarge =>
      super.headlineLarge.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get headlineMedium =>
      super.headlineMedium.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get headlineSmall =>
      super.headlineSmall.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get titleLarge =>
      super.titleLarge.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get titleMedium =>
      super.titleMedium.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get titleSmall =>
      super.titleSmall.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get bodyLarge =>
      super.bodyLarge.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get bodyMedium => super.bodyMedium.copyWith(
    color: _colorScheme.scheme.onSurface.withOpacity(0.95),
  );

  @override
  TextStyle get bodySmall => super.bodySmall.copyWith(
    color: _colorScheme.scheme.onSurface.withOpacity(0.9),
  );

  @override
  TextStyle get labelLarge =>
      super.labelLarge.copyWith(color: _colorScheme.scheme.onSurface);

  @override
  TextStyle get labelMedium => super.labelMedium.copyWith(
    color: _colorScheme.scheme.onSurface.withOpacity(0.95),
  );

  @override
  TextStyle get labelSmall => super.labelSmall.copyWith(
    color: _colorScheme.scheme.onSurface.withOpacity(0.9),
  );

  TextStyle get muted => bodyMedium!.copyWith(
    color: _colorScheme.scheme.onSurface.withOpacity(0.70),
  );

  TextStyle get subtle => bodySmall!.copyWith(
    color: _colorScheme.scheme.onSurface.withOpacity(0.55),
  );
}
