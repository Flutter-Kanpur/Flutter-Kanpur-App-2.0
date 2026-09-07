import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/border_shadow_container.dart';

/// Filter chip row. [onSelect] gets
/// the tapped label, or `null` when the selected chip is tapped again to
/// clear it. "Filters" (index 0) is a no-op - no sheet built yet.
class ContestFilterChipsRow extends StatelessWidget {
  const ContestFilterChipsRow({
    super.key,
    required this.selectedLabel,
    required this.onSelect,
  });

  final String selectedLabel;
  final ValueChanged<String?> onSelect;

  static const _labels = ['Filters', 'DSA', 'Flutter', 'UI/UX', 'Web'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.hardEdge,
      padding: AppSpacing.horizontal(AppSpacing.h20),
      child: Row(
        children: List.generate(_labels.length, (index) {
          final isFilterChip = index != 0;
          final label = _labels[index];
          final isSelected =
              isFilterChip &&
              selectedLabel.toLowerCase() == label.toLowerCase();

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
              borderRadius: 12,
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
                      children: [
                        Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.blackBase,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: AppSpacing.h4),
                          const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.blackBase,
                          ),
                        ],
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      if (!isFilterChip) return;
                      onSelect(isSelected ? null : label);
                    },
                    backgroundColor: AppColors.whiteBase,
                    selectedColor: AppColors.whiteBase,
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
