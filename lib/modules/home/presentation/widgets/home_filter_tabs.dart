import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeFilterTabs extends StatefulWidget {
  const HomeFilterTabs({
    super.key,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
    required this.onFiltersTap,
    this.selectedFiltersCount = 0,
  });

  final int selectedFilterIndex;
  final ValueChanged<int> onFilterSelected;
  final VoidCallback onFiltersTap;

  /// Number of filters currently selected in the bottom sheet (shown on "Filters" chip when > 0).
  final int selectedFiltersCount;

  @override
  State<HomeFilterTabs> createState() => _HomeFilterTabsState();
}

class _HomeFilterTabsState extends State<HomeFilterTabs> {
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isFilterChip = index != 0;
          final isSelected =
              isFilterChip && widget.selectedFilterIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: InnerShadowContainer(
              borderColor: isSelected
                  ? AppColors.selectedNavBarIconColor
                  : AppColors.communityBorderColor,
              shadowColor: AppColors.selectedNavBarIconColor.withOpacity(0.05),
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
                            color: Colors.black,
                          )
                        : null,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          index == 0 && widget.selectedFiltersCount > 0
                              ? '${filters[index]} (${widget.selectedFiltersCount})'
                              : filters[index],
                          style: textStyle_14MediumGreyHintStyle().copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 4.w),
                          Icon(Icons.close, size: 16.sp, color: Colors.black87),
                        ],
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      if (index == 0) {
                        widget.onFiltersTap();
                      } else {
                        widget.onFilterSelected(index);
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    labelStyle: textStyle_14MediumGreyHintStyle().copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: const BorderSide(
                        color: Colors.transparent,
                        // width: isSelected ? 1.5 : 0,
                      ),
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
