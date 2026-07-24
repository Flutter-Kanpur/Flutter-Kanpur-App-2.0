import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ContributorActionCard extends StatelessWidget {
  const ContributorActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

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
          padding: AppSpacing.all08,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 18, child: Icon(icon, size: 18)),
              SizedBox(height: AppSpacing.s09),
              Text(title, style: theme.textTheme.titleMedium),
              SizedBox(height: AppSpacing.s03),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
