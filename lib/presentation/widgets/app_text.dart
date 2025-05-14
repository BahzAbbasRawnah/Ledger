import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A reusable large text widget for headings.
class LargeText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? fontSize;

  const LargeText(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: AppTheme.largeText(
        color: color ?? theme.colorScheme.onBackground,
        fontWeight: fontWeight ?? FontWeight.bold,
        fontSize: fontSize ?? 24.0,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A reusable medium text widget for subheadings and important content.
class MediumText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? fontSize;

  const MediumText(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: AppTheme.mediumText(
        color: color ?? theme.colorScheme.onBackground,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 18.0,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A reusable small text widget for regular content.
class SmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? fontSize;

  const SmallText(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: AppTheme.smallText(
        color: color ?? theme.colorScheme.onBackground,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 14.0,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A reusable extra small text widget for captions and hints.
class ExtraSmallText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? fontSize;

  const ExtraSmallText(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: AppTheme.extraSmallText(
        color: color ?? theme.colorScheme.onBackground,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 12.0,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
