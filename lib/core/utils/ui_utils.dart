import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../data/models/client_model.dart';
import '../../data/models/transaction_model.dart';
import '../../presentation/screens/transactions/add_transaction_screen.dart';
import '../../presentation/utils/snackbar_utils.dart';
import '../localization/app_localizations.dart';

/// A utility class that provides reusable UI operations
/// that are commonly used across multiple screens.
class UiUtils {
  /// Show add transaction bottom sheet
  static void showAddTransactionBottomSheet(
    BuildContext context,
    String clientId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddTransactionBottomSheet(clientId: clientId);
      },
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) async {
    final localizations = AppLocalizations.of(context);
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(cancelText ?? localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                confirmText ?? localizations.confirm,
                style: TextStyle(color: confirmColor),
              ),
            ),
          ],
        );
      },
    );
    
    return result ?? false;
  }

  /// Share file
  static Future<void> shareFile(
    String filePath, {
    String? subject,
  }) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject,
      );
    } catch (e) {
      debugPrint('Error sharing file: $e');
    }
  }

  /// Save file to temporary directory
  static Future<String> saveToTemporaryDirectory(
    List<int> bytes,
    String fileName,
  ) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String? message,
  }) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message ?? localizations.loading),
            ],
          ),
        );
      },
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Show error dialog
  static void showErrorDialog(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? localizations.error),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.ok),
            ),
          ],
        );
      },
    );
  }

  /// Show success dialog
  static void showSuccessDialog(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    final localizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? localizations.success),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.ok),
            ),
          ],
        );
      },
    );
  }
}
