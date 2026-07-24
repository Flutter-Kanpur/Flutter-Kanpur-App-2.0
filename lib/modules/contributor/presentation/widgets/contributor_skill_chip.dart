import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class ContributorSkillChip extends StatelessWidget {
  const ContributorSkillChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.all05),
      backgroundColor: AppColors.whiteBase,
      label: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.whiteBase)),
      deleteIcon: const Icon(Icons.close, size: 18, color: AppColors.whiteBase),
      onDeleted: onDeleted,
    );
  }
}
