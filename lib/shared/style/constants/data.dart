part of '../style.dart';

/// Navigation bar items
List<NavBarItem> mainNavigationBarItems({
  required String homeLabel,
  required String searchLabel,
  required String createMediaLabel,
  required String reelsLabel,
  required String userProfileLabel,
  required Widget userProfileAvatar,
}) =>
    <NavBarItem>[
      NavBarItem(icon: Icons.home_filled, label: homeLabel),
      NavBarItem(icon: Icons.search, label: searchLabel),
      NavBarItem(icon: Icons.add_box_outlined, label: createMediaLabel),
      NavBarItem(icon: Icons.video_collection_outlined, label: reelsLabel),
      NavBarItem(child: userProfileAvatar, label: userProfileLabel),
    ];

class NavBarItem {
  NavBarItem({
    this.icon,
    this.label,
    this.child,
  });

  final String? label;
  final Widget? child;
  final IconData? icon;

  String? get tooltip => label;
}

class GradientColor {
  const GradientColor({required this.hex, this.opacity});

  final String hex;
  final double? opacity;
}

enum PremiumGradient {
  fl0(
    colors: [
      GradientColor(hex: '842CD7'),
      GradientColor(hex: '21F5F1', opacity: .8),
    ],
    stops: [0, 1],
  ),
  telegram(
    colors: [
      GradientColor(hex: '6C93FF'),
      GradientColor(hex: '976FFF'),
      GradientColor(hex: 'DF69D1'),
    ],
    stops: [0, .5, 1],
  );

  const PremiumGradient({
    required this.colors,
    required this.stops,
  });

  final List<GradientColor> colors;
  final List<double> stops;
}

List<String> get commentEmojies =>
    ['🩷', '🙌', '🔥', '👏🏻', '😢', '😍', '😮', '😂'];
