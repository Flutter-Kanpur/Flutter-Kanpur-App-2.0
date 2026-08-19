import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/projects_app_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/upload_project_cta_card.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/application/explore_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_detail.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_dashed_divider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_icon_button_circle.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';
import 'package:flutter_knp_mobile_app_v2/utils/short_date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Single project, reached from "View project details" via
/// `/community/projects/:projectId` - a plain path param, same shape
/// `DiscussionDetailScreen` already uses.
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectDetailProvider(projectId));

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(bottom: AppSpacing.v20),
            children: [
              const ProjectsAppBar(),
              Padding(
                padding: AppSpacing.horizontal(AppSpacing.h20),
                child: projectAsync.when(
                  loading: () => const _ProjectDetailSkeleton(),
                  error: (error, _) => CommunityErrorView(
                    message: 'Could not load this project.',
                    error: error,
                    onRetry: () =>
                        ref.invalidate(projectDetailProvider(projectId)),
                  ),
                  data: (project) => _ProjectDetailContent(project: project),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailContent extends StatelessWidget {
  const _ProjectDetailContent({required this.project});

  final CommunityProjectDetail project;

  bool get _hasLinks =>
      (project.githubUrl?.isNotEmpty ?? false) ||
      (project.figmaUrl?.isNotEmpty ?? false) ||
      (project.liveUrl?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    final sharedOn = project.sharedOn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v18),
        Text(
          project.title,
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        if (project.summary.isNotEmpty) ...[
          SizedBox(height: AppSpacing.v10),
          Text(
            project.summary,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
          ),
        ],
        if (project.techStack.isNotEmpty) ...[
          SizedBox(height: AppSpacing.v16),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: project.techStack
                .map(
                  (tech) =>
                      FkStatusChip(label: tech, color: AppColors.neutral500),
                )
                .toList(),
          ),
        ],
        SizedBox(height: AppSpacing.v16),
        Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
            children: [
              const TextSpan(text: 'Project by '),
              TextSpan(
                text: project.authorName,
                style: const TextStyle(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.v16),
        const FkDashedDivider(),
        SizedBox(height: AppSpacing.v20),
        if (project.description.isNotEmpty) ...[
          Text(
            'About the project',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          Text(
            project.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          SizedBox(height: AppSpacing.v22),
        ],
        if (_hasLinks) ...[
          Text(
            'Project links',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              if (project.githubUrl?.isNotEmpty ?? false) ...[
                FkIconButtonCircle(
                  assetPath: AssetsPath.githubSvg,
                  onTap: () =>
                      openInAppUrlOrNotify(context, project.githubUrl!),
                ),
                SizedBox(width: AppSpacing.h8),
              ],
              if (project.figmaUrl?.isNotEmpty ?? false) ...[
                FkIconButtonCircle(
                  assetPath: AssetsPath.linkIcon,
                  onTap: () =>
                      openInAppUrlOrNotify(context, project.figmaUrl!),
                ),
                SizedBox(width: AppSpacing.h8),
              ],
              if (project.liveUrl?.isNotEmpty ?? false)
                FkIconButtonCircle(
                  assetPath: AssetsPath.liveIcon,
                  onTap: () =>
                      openInAppUrlOrNotify(context, project.liveUrl!),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.v22),
        ],
        if (project.coverImageUrl?.isNotEmpty ?? false) ...[
          Text(
            'Screenshots',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.v12),
          _ScreenshotThumbnail(imageUrl: project.coverImageUrl!),
          SizedBox(height: AppSpacing.v20),
        ],
        if (sharedOn != null) ...[
          Center(
            child: Text(
              'Shared on ${sharedOn.day} ${sharedOn.shortMonth} ${sharedOn.year}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral400,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.v20),
        ],
        UploadProjectCtaCard(
          title: 'Upload new project',
          subtitle:
              'Upload your project and let the community inspired by your work.',
          buttonLabel: 'Upload a new project',
          onPressed: () => context.go(RouteNames.communityUploadProject),
        ),
      ],
    );
  }
}

/// Cover-image thumbnail; tap opens a full-screen pinch-zoom view.
class _ScreenshotThumbnail extends StatelessWidget {
  const _ScreenshotThumbnail({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => _ExpandedScreenshotView(imageUrl: imageUrl),
        ),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.all04,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            height: 160,
            color: AppColors.neutral100,
            child: const Icon(
              Icons.broken_image_outlined,
              color: AppColors.neutral400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedScreenshotView extends StatelessWidget {
  const _ExpandedScreenshotView({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                maxScale: 4,
                child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: AppSpacing.v12,
              right: AppSpacing.h12,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectDetailSkeleton extends StatelessWidget {
  const _ProjectDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.v18),
      child: FkSkeletonPulse(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FkSkeletonBlock(
              width: 220,
              height: 32,
              radius: AppRadius.radius02,
            ),
            SizedBox(height: AppSpacing.v12),
            const FkSkeletonBlock(height: 40, radius: AppRadius.radius02),
            SizedBox(height: AppSpacing.v16),
            Row(
              children: [
                const Expanded(child: FkSkeletonBlock(height: 32, radius: 16)),
                SizedBox(width: AppSpacing.h8),
                const Expanded(child: FkSkeletonBlock(height: 32, radius: 16)),
                SizedBox(width: AppSpacing.h8),
                const Expanded(child: FkSkeletonBlock(height: 32, radius: 16)),
              ],
            ),
            SizedBox(height: AppSpacing.v20),
            const FkSkeletonBlock(height: 80, radius: AppRadius.radius02),
            SizedBox(height: AppSpacing.v20),
            const FkSkeletonBlock(height: 160, radius: AppRadius.radius04),
          ],
        ),
      ),
    );
  }
}
