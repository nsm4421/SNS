import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  _showSnackBar({
    required String message,
    Duration? duration,
    required Color backgroundColor,
    Color textColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyLarge?.copyWith(
            overflow: TextOverflow.ellipsis,
            color: textColor,
          ),
        ),
        action: SnackBarAction(
          label: 'close',
          textColor: textColor,
          onPressed: ScaffoldMessenger.of(this).hideCurrentSnackBar,
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  void showErrorSnackBar(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      backgroundColor: colorScheme.error,
      duration: duration,
    );
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      backgroundColor: colorScheme.primary,
      duration: duration,
    );
  }
}
