import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class FkPrimaryButton extends StatelessWidget {
  const FkPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      label,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.whiteBase,
        fontWeight: FontWeight.w500,
      ),
    );

    // TextButton.icon always reserves the icon's layout space, even when
    // `icon` is null (Icon(null) still lays out as an empty same-size box) -
    // that phantom space was pushing the label off-center. Plain TextButton
    // (no icon slot at all) is used whenever there's no icon to show.
    final Widget button;
    if (isLoading) {
      button = TextButton.icon(
        onPressed: null,
        iconAlignment: IconAlignment.end,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: labelText,
      );
    } else if (icon != null) {
      button = TextButton.icon(
        onPressed: onPressed,
        iconAlignment: IconAlignment.end,
        icon: Icon(icon, color: AppColors.whiteBase),
        label: labelText,
      );
    } else {
      button = TextButton(onPressed: onPressed, child: labelText);
    }

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.blackBase,
          borderRadius: AppRadius.all09,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackBase.withValues(alpha: 0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: button,
      ),
    );
  }
}
