import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContributorActionCard extends StatelessWidget {
  const ContributorActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconAsset,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Optional SVG asset path that, when provided, replaces the default
  /// [icon] CircleAvatar with the asset rendered at its own design (e.g. a
  /// pre-styled circle + icon). Existing callers that don't pass this keep
  /// the original CircleAvatar rendering unchanged.
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.neutral50,
      borderRadius: AppRadius.all04,
      child: InkWell(
        borderRadius: AppRadius.all04,
        onTap: onTap,
        child: Container(
          padding: AppSpacing.all(AppSpacing.h18),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconAsset != null
                  ? SvgPicture.asset(iconAsset!, width: 46, height: 44)
                  : CircleAvatar(radius: 18, child: Icon(icon, size: 18)),
              SizedBox(height: AppSpacing.v20),
              Text(title, style: theme.textTheme.titleMedium),
              SizedBox(height: AppSpacing.v6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
