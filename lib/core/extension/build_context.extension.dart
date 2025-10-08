import 'package:flutter/material.dart';

enum _SnackBarType {
  success(iconData: Icons.check_circle, color: Colors.green),
  warning(iconData: Icons.warning_amber_rounded, color: Colors.orange),
  error(iconData: Icons.error_rounded, color: Colors.red);

  final IconData iconData;
  final Color color;

  const _SnackBarType({required this.iconData, required this.color});
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

extension SnackBarExtension on BuildContext {
  ScaffoldMessengerState? get _scaffoldMessengerState =>
      ScaffoldMessenger.maybeOf(this) ?? scaffoldMessengerKey.currentState;

  void _show({
    required _SnackBarType type,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = Theme.of(this);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: type.color.withAlpha(10),
      elevation: 0,
      duration: duration,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(type.iconData, color: type.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: type.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (_scaffoldMessengerState == null) {
      // 아직 프레임 전/네비 직후면 다음 프레임에 루트로 띄움
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final root = scaffoldMessengerKey.currentState;
        if (root == null) return;
        root
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      });
      return;
    } else {
      _scaffoldMessengerState!
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  showSuccessSnackBar(String message) =>
      _show(type: _SnackBarType.success, message: message);

  showWarningSnackBar(String message) =>
      _show(type: _SnackBarType.warning, message: message);

  showErrorSnackBar(String message) =>
      _show(type: _SnackBarType.error, message: message);
}
