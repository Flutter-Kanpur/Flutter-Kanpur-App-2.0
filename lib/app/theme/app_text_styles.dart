import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Product Sans typography design system.
///
/// Tokens define size, weight, and line height only.
/// Apply color at the call site with `.copyWith(color: ...)`.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'ProductSans';

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
    );
  }

  // Display
  static TextStyle get displayLarge => _style(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        lineHeight: 62,
      );

  static TextStyle get displayMedium => _style(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        lineHeight: 52,
      );

  static TextStyle get displaySmall => _style(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        lineHeight: 44,
      );

  // Headline
  static TextStyle get headlineLarge => _style(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        lineHeight: 40,
      );

  static TextStyle get headlineMedium => _style(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        lineHeight: 36,
      );

  static TextStyle get headlineSmall => _style(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        lineHeight: 32,
      );

  // Title
  static TextStyle get titleLarge => _style(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        lineHeight: 28,
      );

  static TextStyle get titleMedium => _style(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        lineHeight: 24,
      );

  static TextStyle get titleSmall => _style(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        lineHeight: 20,
      );

  // Body
  static TextStyle get bodyLarge => _style(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        lineHeight: 25,
      );

  static TextStyle get bodyMedium => _style(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        lineHeight: 20,
      );

  static TextStyle get bodySmall => _style(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        lineHeight: 16,
      );

  // Label
  static TextStyle get labelLarge => _style(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        lineHeight: 20,
      );

  static TextStyle get labelMedium => _style(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        lineHeight: 16,
      );

  static TextStyle get labelSmall => _style(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        lineHeight: 16,
      );

  /// Material [TextTheme] mapped to this design system.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
