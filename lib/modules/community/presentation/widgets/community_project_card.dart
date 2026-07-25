import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class CommunityProjectCard extends StatelessWidget {
  const CommunityProjectCard({super.key, required this.project});

  final CommunityProject project;

  @override
  Widget build(BuildContext context) {
    return FkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              FkStatusChip(
                label: project.status,
                color: project.status == 'Active'
                    ? AppColors.success600
                    : AppColors.pending400,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v8),
          Text(project.summary),
          SizedBox(height: AppSpacing.v12),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: project.techStack
                .map((tech) => FkStatusChip(label: tech))
                .toList(),
          ),
        ],
      ),
    );
  }
}
