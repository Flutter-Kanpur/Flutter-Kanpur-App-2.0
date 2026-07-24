import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import '../../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class ManageProfileSectionCard extends StatelessWidget {
  const ManageProfileSectionCard({
    super.key,
    required this.title,
    this.value,
    this.tags,
    this.child,
    this.onEdit,
  });

  final String title;
  final String? value;
  final List<String>? tags;
  final Widget? child;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w800),
        ),
        if (value != null) ...[
          SizedBox(height: AppSpacing.s04),
          Text(
            value!,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
        if (child != null) ...[
          SizedBox(height: AppSpacing.s04),
          child!,
        ],
        if (tags != null && tags!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.s06),
          Wrap(
            spacing: AppSpacing.s04,
            runSpacing: AppSpacing.s04,
            children: tags!.map((t) => _SectionPill(label: t)).toList(),
          ),
        ],
        if (onEdit != null) ...[
          SizedBox(height: AppSpacing.s05),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              translate(context, "profile.edit"),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionPill extends StatelessWidget {
  const _SectionPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(horizontal: AppSpacing.s09, vertical: AppSpacing.s05),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        border: Border.all(color: AppBorders.secondary),
        borderRadius: AppRadius.all09,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.neutral900,
        ),
      ),
    );
  }
}
