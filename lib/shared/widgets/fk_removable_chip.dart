import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

/// Filled pill with a trailing ✕, as used for selected tech / category / tags.
///
/// The ✕ is its own tap target so the label itself stays inert — tapping a
/// chip's text should not silently delete a selection.
class FkRemovableChip extends StatelessWidget {
  const FkRemovableChip({
    super.key,
    required this.label,
    required this.onRemove,
    this.color = AppColors.primary500,
    this.foreground = AppColors.whiteBase,
  });

  final String label;
  final VoidCallback onRemove;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.h16,
        right: AppSpacing.h8,
        top: AppSpacing.v8,
        bottom: AppSpacing.v8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.all09,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMedium.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.h6),
          InkWell(
            onTap: onRemove,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.h2),
              child: Icon(Icons.close_rounded, size: 16, color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
