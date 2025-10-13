import 'package:flutter/material.dart';

class PreferredSizedWidgetWrapper extends StatelessWidget
    implements PreferredSizeWidget {
  PreferredSizedWidgetWrapper({
    super.key,
    double? width,
    double? height,
    required this.child,
  }) {
    if (width == null && height != null) {
      _size = Size.fromHeight(height);
    } else if (width != null && height == null) {
      _size = Size.fromWidth(width);
    } else if (width != null && height != null) {
      _size = Size(width, height);
    } else {
      debugPrint('both width, height are null');
      _size = Size.zero;
    }
  }

  final Widget child;
  late final Size _size;

  @override
  Widget build(BuildContext context) => child;

  @override
  Size get preferredSize => _size;
}
