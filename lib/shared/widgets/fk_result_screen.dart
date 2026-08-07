import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.all(AppSpacing.h22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null)
              Image.asset(
                imageAsset!,
                width: 180,
                height: 180,
                fit: BoxFit.contain,
                // Fall back to the drawn circle if the asset is missing, so a
                // bad path degrades instead of showing a broken-image box.
                errorBuilder: (_, _, _) => _GradientBadge(icon: icon, color: color),
              )
            else
              _GradientBadge(icon: icon, color: color),
            SizedBox(height: AppSpacing.v22),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v12),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v22),
            SizedBox(
              width: 220,
              child: buttonIcon == null
                  ? OutlinedButton(
                      onPressed: onPressed,
                      child: Text(buttonLabel),
                    )
                  : OutlinedButton.icon(
                      onPressed: onPressed,
                      icon: Icon(buttonIcon, size: 18),
                      label: Text(buttonLabel),
                    ),
            ),
            if (secondaryLabel != null && onSecondaryPressed != null) ...[
              SizedBox(height: AppSpacing.v12),
              TextButton(
                onPressed: onSecondaryPressed,
                child: Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
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
