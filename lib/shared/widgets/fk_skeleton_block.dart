import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

/// A single loading-placeholder rectangle for skeleton screens. Fills its
/// row's width unless [width] is given (pass a fixed [width] outside of an
/// [Expanded]/[Flexible], or omit it and wrap in one for a flexible share).
class FkSkeletonBlock extends StatelessWidget {
  const FkSkeletonBlock({
    super.key,
    this.width,
    required this.height,
    required this.radius,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
