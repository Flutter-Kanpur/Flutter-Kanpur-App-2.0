import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

RadialGradient backgroundGradiant() {
  return const RadialGradient(
    center: Alignment.center,
    radius: 0.7,
    colors: [
      AppColors.primary950, // Center color (brighter)
      AppColors.blackBase, // Edge color (darker)
    ],
    stops: [0.0, 0.8],
  );
}

List<Color> getBackgroundGradientColors() {
  return [
    AppColors.primary950,
    AppColors.blackBase,
  ];
}

List<Color> getGradientColors(double scrollOffset) {
  double t = (scrollOffset / 300).clamp(0.0, 1.0);
  final centerColor =
      Color.lerp(AppColors.primary950, AppColors.primary950, t)!;
  final edgeColor =
      Color.lerp(AppColors.blackBase, AppColors.blackBase, t)!;
  return [centerColor, edgeColor];
}

Alignment getGradientCenter(double scrollOffset, double scrollPosition) {
  // baseY decreases with scroll to move gradient upward
  double baseY = 0.6 - (scrollOffset / 300);

  return Alignment(0, baseY - 0.9);
}

LinearGradient buttonGradient() {
  return const LinearGradient(
    colors: [
      AppColors.primary400, // Sky blue
      AppColors.primary400, // Holds blue till mid
      AppColors.blackBase, // Deep dark
    ],
    stops: [0.0, 0.5, 1.0], // Transition at mid-point
    begin: Alignment.centerLeft,
    end: Alignment.bottomCenter,
  );
}

// Gradient text utilities
LinearGradient titleGradient() {
  return const LinearGradient(
    colors: [
      AppColors.whiteBase, // Sky blue// Light blue

      // Sky blue// Light blue
      AppColors.primary300, // Light green
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

LinearGradient eventTitleGradient() {
  return const LinearGradient(
    colors: [
      AppColors.primary400, // Sky blue
      AppColors.primary300, // Light blue
      AppColors.primary300, // Blue
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// Widget for gradient text
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = const LinearGradient(
      colors: [AppColors.whiteBase, AppColors.primary300],
    ),
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
