import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/community_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_project_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class UploadProjectLandingScreen extends ConsumerWidget {
  const UploadProjectLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingProjectsAsync = ref.watch(myPendingProjectsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(myPendingProjectsProvider.notifier).refresh(),
      child: FkScreen(
        scrollPhysics: const AlwaysScrollableScrollPhysics(),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.community);
                }
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          SizedBox(height: AppSpacing.v22),
          Text(
            'Showcase your work and inspire other community members.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLarge,
          ),
          SizedBox(height: AppSpacing.v22),
          const _TimelineStep(
            title: 'Submit your project',
            body:
                'Share your project details, tech stack, and relevant links for review.',
            isFirst: true,
          ),
          const _TimelineStep(
            title: 'Review by the community team',
            body:
                'Our team reviews submissions to ensure relevance and community value.',
          ),
          const _TimelineStep(
            title: 'Approved and published',
            body:
                'Once approved, your project is published and visible to the community.',
            isLast: true,
          ),
          SizedBox(height: AppSpacing.v22),
          Container(
            padding: AppSpacing.all(AppSpacing.h22),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: AppRadius.all04,
            ),
            child: Column(
              children: [
                Text(
                  'Ready to share your project?',
                  style: AppTextStyles.titleMedium,
                ),
                SizedBox(height: AppSpacing.v10),
                Text(
                  'Upload your project and let the community inspired by your work.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.subtitleTextDarkGrey,
                  ),
                ),
                SizedBox(height: AppSpacing.v18),
                SizedBox(
                  width: 200,
                  child: FkPrimaryButton(
                    label: 'Upload project',
                    icon: null,
                    // push, not go, so the form's back arrow returns here
                    onPressed: () =>
                        context.push(RouteNames.communityUploadProjectForm),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          Text(
            'Submitted for review',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.v6),
          Text(
            'Projects you have uploaded and are waiting for team approval.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.subtitleTextDarkGrey,
            ),
          ),
          SizedBox(height: AppSpacing.v16),
          pendingProjectsAsync.when(
            loading: () => const CommunityLoadingView(height: 120),
            error: (error, _) => CommunityErrorView(
              compact: true,
              error: error,
              message: 'Could not load your submitted projects.',
              onRetry: () =>
                  ref.read(myPendingProjectsProvider.notifier).refresh(),
            ),
            data: (projects) {
              if (projects.isEmpty) {
                return const CommunityEmptyView(
                  icon: Icons.folder_open_outlined,
                  message:
                      'No projects pending review. Upload a project to see it here.',
                );
              }

              return Column(
                children: [
                  for (final project in projects)
                    CommunityProjectCard(project: project),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.body,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final String body;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.whiteBase,
                  size: 18,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: AppSpacing.h6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0, 1],
                        colors: [
                          AppColors.whiteBase,
                          AppColors.primary500,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.h16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.v22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
                  ),
                  SizedBox(height: AppSpacing.v6),
                  Text(
                    body,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.subtitleTextDarkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
