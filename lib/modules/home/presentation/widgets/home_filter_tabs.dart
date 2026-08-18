import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class HomeFilterTabs extends StatelessWidget {
  const HomeFilterTabs({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
    required this.onFiltersTap,
    required this.onFilterCleared,
    this.selectedFiltersCount = 0,
  });

  final int selectedFilterIndex;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback onFiltersTap;
  final ValueChanged<int> onFilterCleared;

  final int selectedFiltersCount;

  @override
  Widget build(BuildContext context) {
    final filters = [
      'home.filterTabs.filters'.tr(),
      'home.filterTabs.myEvents'.tr(),
      'home.filterTabs.announcements'.tr(),
      'home.filterTabs.upcoming'.tr(),
      'home.filterTabs.past'.tr(),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.horizontal(AppSpacing.h20),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isFilterChip = index != 0;
          final isSelected = isFilterChip && selectedFilterIndex == index;

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.h8),
            child: InnerShadowContainer(
              borderColor: isSelected
                  ? AppColors.primary500
                  : AppColors.neutral100,
              shadowColor: AppColors.primary500.withValues(alpha: 0.05),
              isShadowBottomLeft: true,
              isShadowBottomRight: true,
              isShadowTopLeft: true,
              isShadowTopRight: true,
              borderRadius: 12.r,
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: FilterChip(
                    showCheckmark: false,

                    avatar: index == 0
                        ? const Icon(
                            Icons.filter_list_rounded,
                            color: AppColors.blackBase,
                          )
                        : null,

                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          index == 0 && selectedFiltersCount > 0
                              ? '${filters[index]} ($selectedFiltersCount)'
                              : filters[index],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.blackBase,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        if (isSelected) ...[
                          SizedBox(width: AppSpacing.h4),

                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              onFilterCleared(index);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(2.w),
                              child: Icon(
                                Icons.close,
                                size: 16.sp,
                                color: AppColors.blackBase,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    selected: isSelected,

                    onSelected: (_) {
                      if (index == 0) {
                        onFiltersTap();
                      } else {
                        onFilterSelected(index);
                      }
                    },

                    backgroundColor: AppColors.whiteBase,
                    selectedColor: AppColors.whiteBase,

                    labelStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.blackBase,
                      fontWeight: FontWeight.w500,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all02,
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
