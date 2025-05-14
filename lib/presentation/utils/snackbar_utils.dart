import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// A utility class for showing consistent SnackBars throughout the app.
class SnackBarUtils {
  /// Shows a success SnackBar with the given message.
  ///
  /// The SnackBar has a green background and a check icon.
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppTheme.successColor,
      icon: Icons.check_circle,
      duration: duration,
      action: action,
    );
  }

  /// Shows an error SnackBar with the given message.
  ///
  /// The SnackBar has a red background and an error icon.
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppTheme.errorColor,
      icon: Icons.error,
      duration: duration,
      action: action,
    );
  }

  /// Shows a warning SnackBar with the given message.
  ///
  /// The SnackBar has an orange background and a warning icon.
  static void showWarningSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppTheme.warningColor,
      icon: Icons.warning,
      duration: duration,
      action: action,
    );
  }

  /// Shows an info SnackBar with the given message.
  ///
  /// The SnackBar has a blue background and an info icon.
  static void showInfoSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: AppTheme.infoColor,
      icon: Icons.info,
      duration: duration,
      action: action,
    );
  }

  /// Private helper method to show a SnackBar with the given parameters.
  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      action: action,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
