import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class SearchEventResultTile extends StatelessWidget {
  const SearchEventResultTile({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    this.description,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final String date;
  final String status;
  final String? description;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.h10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.all05,
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            Container(
              width: 72.w,
              height: 72.h,
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: AppRadius.all03,
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Icon(
                          Icons.event_outlined,
                          color: AppColors.primary500,
                          size: 26.sp,
                        );
                      },
                    )
                  : Icon(
                      Icons.event_outlined,
                      color: AppColors.primary500,
                      size: 26.sp,
                    ),
            ),

            SizedBox(width: AppSpacing.h12),

            // Event information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (description != null && description!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],

                  SizedBox(height: 6.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h8,
                      vertical: AppSpacing.v4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: AppRadius.all02,
                    ),
                    child: Text(
                      status,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 4.w),

            Icon(Icons.chevron_right, size: 20.sp, color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }
}
