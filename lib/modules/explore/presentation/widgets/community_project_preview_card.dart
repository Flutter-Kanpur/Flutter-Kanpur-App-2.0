import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/storage/app_prefs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_icon_button_circle.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/utils/external_links.dart';
import 'package:go_router/go_router.dart';

/// Project preview card with author/date/links and a locally-persisted like
/// (no server-side like table for projects).
class CommunityProjectPreviewCard extends StatefulWidget {
  const CommunityProjectPreviewCard({super.key, required this.project});

  final CommunityProjectPreview project;

  @override
  State<CommunityProjectPreviewCard> createState() =>
      _CommunityProjectPreviewCardState();
}

class _CommunityProjectPreviewCardState
    extends State<CommunityProjectPreviewCard> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikedState();
  }

  Future<void> _loadLikedState() async {
    final ids = await AppPrefs.getLikedProjectIds();
    if (!mounted) return;
    setState(() => _isLiked = ids.contains(widget.project.id));
  }

  Future<void> _toggleLiked() async {
    final next = !_isLiked;
    setState(() => _isLiked = next);

    final ids = await AppPrefs.getLikedProjectIds();
    next ? ids.add(widget.project.id) : ids.remove(widget.project.id);
    await AppPrefs.setLikedProjectIds(ids);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return FkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: _toggleLiked,
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? AppColors.errorFg : AppColors.neutral400,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v8),
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
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'project by',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral400,
                      ),
                    ),
                    Text(
                      project.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.h8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'posted on',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.neutral400,
                    ),
                  ),
                  Text(
                    project.postedOn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push(
                    '${RouteNames.communityProjects}/${project.id}',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blackBase,
                    foregroundColor: AppColors.whiteBase,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h12,
                      vertical: AppSpacing.v10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all09,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'View project details',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (project.githubUrl != null &&
                  project.githubUrl!.isNotEmpty) ...[
                SizedBox(width: AppSpacing.h6),
                FkIconButtonCircle(
                  assetPath: AssetsPath.githubSvg,
                  onTap: () =>
                      openInAppUrlOrNotify(context, project.githubUrl!),
                ),
              ],
              if (project.figmaUrl != null &&
                  project.figmaUrl!.isNotEmpty) ...[
                SizedBox(width: AppSpacing.h6),
                FkIconButtonCircle(
                  assetPath: AssetsPath.linkIcon,
                  onTap: () =>
                      openInAppUrlOrNotify(context, project.figmaUrl!),
                ),
              ],
              if (project.liveUrl != null && project.liveUrl!.isNotEmpty) ...[
                SizedBox(width: AppSpacing.h6),
                FkIconButtonCircle(
                  assetPath: AssetsPath.liveIcon,
                  onTap: () =>
                      openInAppUrlOrNotify(context, project.liveUrl!),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
