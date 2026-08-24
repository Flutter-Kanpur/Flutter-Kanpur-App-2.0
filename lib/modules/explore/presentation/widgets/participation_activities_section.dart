import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/widgets/contributor_action_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';

/// Events/Contests/Open Calls tiles. Reuses ContributorActionCard as-is
/// rather than introducing a near-duplicate tile widget.
class ParticipationActivitiesSection extends StatelessWidget {
  const ParticipationActivitiesSection({
    super.key,
    required this.onEventsTap,
    required this.onContestsTap,
    required this.onOpenCallsTap,
  });

  final VoidCallback onEventsTap;
  final VoidCallback onContestsTap;
  final VoidCallback onOpenCallsTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FkSectionTitle(title: 'Participation & activities'),
        Row(
          children: [
            Expanded(
              child: ContributorActionCard(
                icon: Icons.code,
                iconAsset: AssetsPath.codeIcon,
                title: 'Events',
                subtitle: 'Meetups, workshops, and sessions.',
                onTap: onEventsTap,
              ),
            ),
            SizedBox(width: AppSpacing.h12),
            Expanded(
              child: ContributorActionCard(
                icon: Icons.code,
                iconAsset: AssetsPath.codeIcon,
                title: 'Open Calls',
                subtitle: 'Speakers, volunteers, and contributors.',
                onTap: onOpenCallsTap,
              ),
            ),
            // Expanded(
            //   child: ContributorActionCard(
            //     icon: Icons.code,
            //     iconAsset: AssetsPath.codeIcon,
            //     title: 'Contests',
            //     subtitle: 'Coding challenges and sprints.',
            //     onTap: onContestsTap,
            //   ),
            // ),
          ],
        ),
        // SizedBox(height: AppSpacing.v12),
        // Row(
        //   children: [
        //     Expanded(
        //       child: ContributorActionCard(
        //         icon: Icons.code,
        //         iconAsset: AssetsPath.codeIcon,
        //         title: 'Open Calls',
        //         subtitle: 'Speakers, volunteers, and contributors.',
        //         onTap: onOpenCallsTap,
        //       ),
        //     ),
        //     SizedBox(width: AppSpacing.h12),
        //     const Expanded(child: SizedBox.shrink()),
        //   ],
        // ),
      ],
    );
  }
}
