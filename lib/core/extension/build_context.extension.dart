import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  showSuccessSnackBar(String text) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(this).textTheme.bodyMedium?.copyWith(
              color: Theme.of(this).colorScheme.onPrimaryContainer,
            ),
          ),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(this).colorScheme.primaryContainer,
        ),
      );
  }

  showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(this).textTheme.bodyMedium?.copyWith(
              color: Theme.of(this).colorScheme.onErrorContainer,
            ),
          ),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(this).colorScheme.errorContainer,
        ),
      );
  }
}
