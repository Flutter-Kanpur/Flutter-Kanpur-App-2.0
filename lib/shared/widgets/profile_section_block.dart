import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

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
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text(
              title,
              style: textStyle_16RegularGrey().copyWith(
                color: AppColors.subtitleTextDarkGrey,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.profileSectionBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                for (int i = 0; i < tiles.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.textWhite,
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
