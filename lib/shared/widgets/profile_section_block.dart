import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

/// Groups a section title and its tiles in one rounded container with dividers between items.
class ProfileSectionBlock extends StatelessWidget {
  const ProfileSectionBlock({
    super.key,
    required this.title,
    required this.tiles,
  });

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.only(left: AppSpacing.s09, top: AppSpacing.s00, right: AppSpacing.s09, bottom: AppSpacing.s09),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.s02),
            child: Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.s04),
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: AppRadius.all03,
            ),
            child: Column(
              children: [
                for (int i = 0; i < tiles.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: AppSpacing.horizontal(AppSpacing.s09),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.whiteBase,
                      ),
                    ),
                  tiles[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
