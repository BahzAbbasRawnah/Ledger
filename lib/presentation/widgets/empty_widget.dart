import 'package:flutter/material.dart';

/// A reusable widget to display when a list or collection is empty.
/// 
/// This widget shows a centered column with an icon, message, and optional action button.
class EmptyWidget extends StatelessWidget {
  /// The message to display below the icon
  final String message;
  
  /// The icon to display above the message
  final IconData icon;
  
  /// The color of the icon
  final Color? iconColor;
  
  /// The size of the icon
  final double iconSize;
  
  /// Optional action button text
  final String? actionText;
  
  /// Optional callback for when the action button is pressed
  final VoidCallback? onAction;

  const EmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.sentiment_dissatisfied,
    this.iconColor,
    this.iconSize = 80.0,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
