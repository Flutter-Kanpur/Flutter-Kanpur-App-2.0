import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/suggested_job_preview_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/presentation/widgets/suggested_job_preview_card_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Watches [suggestedJobsProvider] directly (rather than receiving a list
/// prop), matching CommunityProjectsPreviewSection's pattern now that this
/// provider is async too.
class SuggestedJobsPreviewSection extends ConsumerWidget {
  const SuggestedJobsPreviewSection({super.key, required this.onViewAllTap});

  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(suggestedJobsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FkSectionTitle(
          title: 'Suggested jobs',
          actionLabel: 'View all',
          onActionTap: onViewAllTap,
        ),
        jobsAsync.when(
          loading: () => const Column(
            children: [
              SuggestedJobPreviewCardSkeleton(),
              SuggestedJobPreviewCardSkeleton(),
            ],
          ),
          error: (error, _) => CommunityErrorView(
            message: 'Could not load suggested jobs.',
            error: error,
            compact: true,
            onRetry: () => ref.invalidate(suggestedJobsProvider),
          ),
          data: (jobs) {
            if (jobs.isEmpty) return const SizedBox.shrink();
            return Column(
              children: [
                for (final job in jobs)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.v12),
                    child: SuggestedJobPreviewCard(job: job),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
