import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class ContributorSummaryCard extends StatelessWidget {
  const ContributorSummaryCard({
    super.key,
    required this.tasksCompleted,
    required this.eventsContributed,
    required this.activeTasks,
  });

  final String tasksCompleted;
  final String eventsContributed;
  final String activeTasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all04,
        border: Border.all(color: AppBorders.secondary),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackBase.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              value: tasksCompleted,
              label: "contributor.tasksCompleted",
              theme: theme,
            ),
          ),
          Expanded(
            child: _SummaryItem(
              value: eventsContributed,
              label: "contributor.eventsContributed",
              theme: theme,
            ),
          ),
          Expanded(
            child: _SummaryItem(
              value: activeTasks,
              label: "contributor.activeTasks",
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.value,
    required this.label,
    required this.theme,
  });

  final String value;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.blackBase,
          ),
        ),
        SizedBox(height: AppSpacing.v4),
        Text(
          label.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.neutral500,
          ),
        ),
      ],
    );
  }
}
