import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
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
      padding: AppSpacing.only(
        left: AppSpacing.h20,
        top: 0,
        right: AppSpacing.h20,
        bottom: AppSpacing.v20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.v4),
            child: Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.v8),
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
                      padding: AppSpacing.horizontal(AppSpacing.h20),
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
