import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/sandbox/app-colors.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.appBackgroundV2,
      label: Text(label, style: TextStyle(color: AppColors.textWhite)),
      deleteIcon: const Icon(Icons.close, size: 18, color: AppColors.textWhite),
      onDeleted: onDeleted,
    );
  }
}
