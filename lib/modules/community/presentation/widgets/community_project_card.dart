import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/community_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';

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
                    ? AppColors.successColor
                    : AppColors.warningColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(project.summary),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.techStack
                .map((tech) => FkStatusChip(label: tech))
                .toList(),
          ),
        ],
      ),
    );
  }
}
