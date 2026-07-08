import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application/my_events_state.dart';

/// Category filter pills for the My Events screen (Upcoming/Past/Missed/Saved).
/// Meant to sit above the event list, outside its scroll view, so it stays fixed.
class MyEventsFilterTabs extends StatelessWidget {
  const MyEventsFilterTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  final MyEventsTab selectedTab;
  final ValueChanged<MyEventsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: MyEventsTab.values.map((tab) {
          final isSelected = tab == selectedTab;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: isSelected
                      ? null
                      : Border.all(color: AppColors.contributorFieldBorder),
                ),
                child: Text(
                  tab.label,
                  style: isSelected
                      ? textStyle_16MediumBlack().copyWith(color: Colors.white)
                      : textStyle_16MediumBlack(),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
