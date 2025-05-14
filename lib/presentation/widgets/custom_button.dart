import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final IconData? icon;
  final double? widthPercentage; // Width as percentage of screen width

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.icon,
    this.widthPercentage, // Default is null (full width)
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate button width based on percentage if provided
    final buttonWidth =
        widthPercentage != null ? screenWidth * (widthPercentage! / 100) : null;

    Widget button;
    if (isOutlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? theme.primaryColor,
          side: BorderSide(color: color ?? theme.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _buildButtonContent(),
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _buildButtonContent(),
      );
    }

    // Wrap with SizedBox if width percentage is provided
    if (buttonWidth != null) {
      return Center(
        child: SizedBox(
          width: buttonWidth,
          child: button,
        ),
      );
    }

    return button;
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const SpinKitThreeBounce(
        color: Colors.white,
        size: 24,
      );
    } else if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      return Text(text);
    }
  }
}
