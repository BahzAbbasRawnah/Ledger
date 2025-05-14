import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A reusable rounded container widget with customizable properties.
class RoundedContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final bool hasShadow;
  final Alignment alignment;

  const RoundedContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.hasShadow = false,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: AppTheme.roundedContainerDecoration(
        backgroundColor: backgroundColor ?? theme.colorScheme.surface,
        borderColor: borderColor ?? Colors.transparent,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// A reusable card container with shadow.
class CardContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final Alignment alignment;

  const CardContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: AppTheme.cardDecoration(
        backgroundColor: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// A reusable header container for tables, sections, etc.
class HeaderContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final Alignment alignment;

  const HeaderContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: AppTheme.headerDecoration(
        backgroundColor: backgroundColor ?? AppTheme.primaryColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// A reusable footer container for tables, sections, etc.
class FooterContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;
  final Alignment alignment;

  const FooterContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: AppTheme.footerDecoration(
        backgroundColor: backgroundColor ?? AppTheme.primaryColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// A reusable section container with header and content.
class SectionContainer extends StatelessWidget {
  final Widget headerChild;
  final Widget contentChild;
  final Widget? footerChild;
  final Color? headerBackgroundColor;
  final Color? contentBackgroundColor;
  final Color? footerBackgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry footerPadding;
  final EdgeInsetsGeometry margin;
  final double? width;

  const SectionContainer({
    super.key,
    required this.headerChild,
    required this.contentChild,
    this.footerChild,
    this.headerBackgroundColor,
    this.contentBackgroundColor,
    this.footerBackgroundColor,
    this.borderRadius = 8.0,
    this.headerPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.contentPadding = const EdgeInsets.all(16.0),
    this.footerPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: headerPadding,
              color: headerBackgroundColor ?? AppTheme.primaryColor,
              child: headerChild,
            ),

            // Content
            Container(
              padding: contentPadding,
              color: contentBackgroundColor ?? theme.colorScheme.surface,
              child: contentChild,
            ),

            // Footer (optional)
            if (footerChild != null)
              Container(
                padding: footerPadding,
                color: footerBackgroundColor ?? AppTheme.primaryColor,
                child: footerChild,
              ),
          ],
        ),
      ),
    );
  }
}
