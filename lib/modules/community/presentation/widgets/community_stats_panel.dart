import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommunityStatsPanel extends StatelessWidget {
  const CommunityStatsPanel({
    super.key,
    this.memberCount = '120+',
    this.contributionCount = '150+',
    this.eventsCount = '25+',
  });

  final String memberCount;
  final String contributionCount;
  final String eventsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v20),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: memberCount, label: 'Community\nmembers'),
          _StatItem(value: contributionCount, label: 'Community\ncontributions'),
          _StatItem(value: eventsCount, label: 'Events\nhosted'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: AppSpacing.v6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.neutral500,
              ),
        ),
      ],
    );
  }
}
