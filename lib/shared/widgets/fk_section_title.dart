import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class FkSectionTitle extends StatelessWidget {
  const FkSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.v8, bottom: AppSpacing.v8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleMedium,
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onActionTap, child: Text(actionLabel!,style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary500))),
        ],
      ),
    );
  }
}
