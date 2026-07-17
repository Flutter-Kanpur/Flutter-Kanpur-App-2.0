import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Generic selectable pill filter row (e.g. Upcoming/Past/Missed/Saved on My
/// Events, Ongoing/Upcoming/Past on My Contests). Meant to sit above a list,
/// outside its scroll view, so it stays fixed while the list scrolls.
///
/// The active pill is always reshuffled to the front; the rest keep their
/// original relative order behind it. [selectedIndex]/[onChanged] still
/// refer to positions in [labels], not to the reshuffled display order —
/// callers don't need to know reshuffling happens.
class PillFilterTabs extends StatelessWidget {
  const PillFilterTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();

    final displayOrder = [
      selectedIndex,
      for (var i = 0; i < labels.length; i++) if (i != selectedIndex) i,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: displayOrder.map((index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(index),
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
                  labels[index],
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
