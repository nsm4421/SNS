part of 'app_color.dart';

/// 앱 전역에서 재사용할 '색상 토큰' 모음.
@immutable
class AppPalette {
  const AppPalette._();

  /// 메인 브랜드 그린 (Spotify Green)
  static const Color brandGreen = Color(0xFF1DB954);

  /// 조금 더 밝은 포인트 그린 (호버/포커스/그라데이션 앞쪽)
  static const Color brandGreenBright = Color(0xFF1ED760);

  /// 살짝 어두운 그린 (프레스드/딥톤)
  static const Color brandGreenDark = Color(0xFF169C46);

  /// 브랜드 블랙(다크 배경의 기본)
  static const Color brandBlack = Color(0xFF121212);

  /// 다크 서피스(카드/컨테이너)
  static const Color brandSurfaceDark = Color(0xFF181818);

  /// 다크 아웃라인/디바이더
  static const Color brandOutlineDark = Color(0xFF282828);

  /// 라이트 배경 기본
  static const Color brandWhite = Color(0xFFFFFFFF);

  /// 라이트 서피스(카드/컨테이너)
  static const Color brandSurfaceLight = Color(0xFFF7F7F7);

  /// 라이트 아웃라인/디바이더
  static const Color brandOutlineLight = Color(0xFFE6E6E6);

  /// 보조 텍스트 톤 (다크에서 #B3B3B3 감성)
  static const Color textMutedDark = Color(0xFFB3B3B3);

  /// 보조 텍스트 톤 (라이트)
  static const Color textMutedLight = Color(0xFF6B7280);

  // ================
  // Neutrals (공통 중립 팔레트)
  // ================
  static const Color neutral99 = Color(0xFFFAFAFA); // 라이트 최상단 배경
  static const Color neutral95 = Color(0xFFF2F2F3);
  static const Color neutral90 = Color(0xFFE8E8EA);

  static const Color neutral20 = Color(0xFF303236); // 다크 서페이스 대비 중립
  static const Color neutral12 = Color(0xFF202226); // 다크 배경 보조
  static const Color neutral06 = Color(0xFF16181B); // 다크 딥 배경

  // ================
  // Semantic
  // ================
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ================
  // Overlays (투명 오버레이)
  // ================
  /// 검정 20% 오버레이 (버튼 프레스/모달 백드롭 등)
  static const Color overlayBlack20 = Color(0x33000000);

  /// 흰색 20% 오버레이
  static const Color overlayWhite20 = Color(0x33FFFFFF);

  // ================
  // Helpers
  // ================
  /// 브랜드 그린 그라데이션 (상단 밝게 → 하단 기본)
  static Gradient brandGreenGradient({
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: const [brandGreenBright, brandGreen],
    );
  }
}
