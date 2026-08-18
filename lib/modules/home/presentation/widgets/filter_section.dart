import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/filter_option_chip.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  final String title;
  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.blackBase,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 7.h),

          Wrap(
            spacing: 10.w,
            runSpacing: 7.h,
            children: options.map((option) {
              return FilterOptionChip(
                label: option,
                isSelected: selectedOptions.contains(option),
                onTap: () => onOptionSelected(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
