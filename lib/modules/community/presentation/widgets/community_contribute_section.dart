import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class CommunityContributeCard extends StatelessWidget {
  const CommunityContributeCard({
    super.key,
    required this.label,
    required this.body,
    required this.onTap,
    this.title,
  });

  final String label;
  final String? title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.all07,
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all04,
          border: Border.all(color: AppBorders.tertiary),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary500.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSpacing.s06, vertical: AppSpacing.s07),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: AppRadius.all09,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: AppColors.whiteBase),
              ),
            ),
            if (title != null) ...[
              SizedBox(height: AppSpacing.s07),
              Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.whiteBase, fontWeight: FontWeight.w500),
              ),
            ],
            SizedBox(height: AppSpacing.s06),
            Expanded(
              child: Text(
                body,
                overflow: TextOverflow.ellipsis,
                maxLines: title == null ? 4 : 5,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.36,
                      color: title == null
                          ? AppColors.blackBase
                          : AppColors.neutral500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
