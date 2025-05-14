import 'package:flutter/material.dart';
import 'app_theme.dart';

/// A utility class that provides reusable text styles and container decorations
/// for consistent UI across the app.
class AppStyles {
  // Text Styles
  
  /// Large text style for headings
  static TextStyle largeText({
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
    double fontSize = 24.0,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
  
  /// Medium text style for subheadings and important content
  static TextStyle mediumText({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 18.0,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
  
  /// Small text style for regular content
  static TextStyle smallText({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 14.0,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
  
  /// Extra small text style for captions and hints
  static TextStyle extraSmallText({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 12.0,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
  
  // Container Decorations
  
  /// Rounded container decoration with optional border and shadow
  static BoxDecoration roundedContainerDecoration({
    Color? backgroundColor,
    Color borderColor = Colors.transparent,
    double borderRadius = 12.0,
    double borderWidth = 1.0,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      boxShadow: boxShadow,
    );
  }
  
  /// Card decoration with shadow
  static BoxDecoration cardDecoration({
    Color? backgroundColor,
    double borderRadius = 12.0,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  /// Header container decoration (for table headers, section headers, etc.)
  static BoxDecoration headerDecoration({
    Color? backgroundColor,
    double borderRadius = 8.0,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppTheme.primaryColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
    );
  }
  
  /// Footer container decoration (for table footers, section footers, etc.)
  static BoxDecoration footerDecoration({
    Color? backgroundColor,
    double borderRadius = 8.0,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppTheme.primaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
    );
  }
  
  // Common Paddings
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16.0);
  static const EdgeInsets largePadding = EdgeInsets.all(24.0);
  
  // Horizontal Paddings
  static const EdgeInsets horizontalSmallPadding = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets horizontalMediumPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets horizontalLargePadding = EdgeInsets.symmetric(horizontal: 24.0);
  
  // Vertical Paddings
  static const EdgeInsets verticalSmallPadding = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets verticalMediumPadding = EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets verticalLargePadding = EdgeInsets.symmetric(vertical: 24.0);
}
