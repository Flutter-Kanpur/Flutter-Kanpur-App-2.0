import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';

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
      child: InnerShadowContainer(
        alignment: Alignment.topLeft,
        shadowColor: const Color(0XFFB3C4FF).withOpacity(0.08),
        isShadowBottomLeft: true,
        isShadowBottomRight: true,
        isShadowTopLeft: true,
        isShadowTopRight: true,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.h12,
                    vertical: AppSpacing.v4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    borderRadius: AppRadius.all09,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.whiteBase,
                    ),
                  ),
                ),
                if (title != null && title!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.v16),
                  Text(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.blackBase,
                    ),
                  ),
                ],
                SizedBox(
                  height: title == null ? AppSpacing.v6 : AppSpacing.v16,
                ),
                Expanded(
                  child: Text(
                    body,
                    overflow: TextOverflow.ellipsis,
                    maxLines: title == null ? 4 : 5,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      height: 1.30,
                      color: title == null
                          ? AppColors.blackBase
                          : AppColors.neutral500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
