import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class FkResultScreen extends StatelessWidget {
  const FkResultScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonIcon,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.imageAsset,
  });

  /// Illustration to show instead of the gradient circle + [icon].
  /// When set, [icon] and [color] only affect the button styling.
  final String? imageAsset;

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String buttonLabel;
  final VoidCallback onPressed;

  /// Optional leading icon inside the primary button (Figma: 👁 View discussion).
  final IconData? buttonIcon;

  /// Optional text link under the primary button (Figma: "Post another question").
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: AppSpacing.all(AppSpacing.h22),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageAsset != null)
              imageAsset!.endsWith('.svg')
                  ? SvgPicture.asset(
                      imageAsset!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      placeholderBuilder: (_) =>
                          _GradientBadge(icon: icon, color: color),
                    )
                  : Image.asset(
                      imageAsset!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (_, _, _) =>
                          _GradientBadge(icon: icon, color: color),
                    )
            else
              _GradientBadge(icon: icon, color: color),
            SizedBox(height: AppSpacing.v22),
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackBase,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.v12),
            SizedBox(
              width: double.infinity,
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.neutral500,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.v22),
            SizedBox(
              width: 260,
              child: OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blackBase,
                  backgroundColor: AppColors.whiteBase,
                  side: const BorderSide(color: AppBorders.primary),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                child: buttonIcon == null
                    ? Text(
                        buttonLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.blackBase,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            buttonIcon,
                            size: 18,
                            color: AppColors.blackBase,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              buttonLabel,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.blackBase,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (secondaryLabel != null && onSecondaryPressed != null) ...[
              SizedBox(height: AppSpacing.v12),
              TextButton(
                onPressed: onSecondaryPressed,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.blackBase,
                ),
                child: Text(
                  secondaryLabel!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.blackBase,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}

/// Drawn fallback badge, used when no [FkResultScreen.imageAsset] is supplied
/// or the asset fails to load.
class _GradientBadge extends StatelessWidget {
  const _GradientBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.65), color],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Icon(icon, size: 70, color: AppColors.whiteBase),
    );
  }
}
