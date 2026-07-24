import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ContributorHelpBottomSheet extends StatelessWidget {
  const ContributorHelpBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, AppSpacing.s06, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: AppSpacing.s05,
              decoration: BoxDecoration(
                color: AppColors.neutral400,
                borderRadius: AppRadius.all09,
              ),
            ),

            SizedBox(height: AppSpacing.s10),

            _HelpTile(
              icon: Icons.visibility_outlined,
              title: "contributor.viewContributorGuidelines".tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: AppSpacing.s07),

            _HelpTile(
              icon: Icons.edit_outlined,
              title: "contributor.reportIssue".tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  const _HelpTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: AppRadius.all03,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.vertical(AppSpacing.s06),
        child: Row(
          children: [
            Icon(icon, size: 22),

            SizedBox(width: AppSpacing.s07),

            Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}
