import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ContributorHelpBottomSheet extends StatelessWidget {
  const ContributorHelpBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.textGrey,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 28),

            _HelpTile(
              icon: Icons.visibility_outlined,
              title: "contributor.viewContributorGuidelines".tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 16),

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
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22),

            const SizedBox(width: 14),

            Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
}
