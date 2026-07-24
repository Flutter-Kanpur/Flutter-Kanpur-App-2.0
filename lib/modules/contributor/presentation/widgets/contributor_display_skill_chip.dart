import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class ContributorDisplaySkillChip extends StatelessWidget {
  const ContributorDisplaySkillChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(horizontal: AppSpacing.s06, vertical: AppSpacing.s04),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all02,
        border: Border.all(color: AppBorders.tertiary),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
