import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s09),
      child: Row(
        children: displayOrder.map((index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.s04),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s08, vertical: AppSpacing.s05),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary500 : AppColors.whiteBase,
                  borderRadius: AppRadius.all09,
                  border: isSelected
                      ? null
                      : Border.all(color: AppBorders.primary),
                ),
                child: Text(
                  labels[index],
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isSelected
                        ? AppColors.whiteBase
                        : AppColors.blackBase,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
