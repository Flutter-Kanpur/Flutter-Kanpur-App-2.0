import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Richer preview card than the real CommunityProjectCard (which has no
/// author/date/CTA fields) - built fresh for the Explore dashboard using
/// sample data. The like heart is decorative local state, not persisted.
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
                onPressed: () => setState(() => _isLiked = !_isLiked),
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
                  onPressed: () {},
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
              SizedBox(width: AppSpacing.h6),
              _IconButtonCircle(assetPath: AssetsPath.githubSvg, onTap: () {}),
              SizedBox(width: AppSpacing.h6),
              _IconButtonCircle(assetPath: AssetsPath.linkIcon, onTap: () {}),
              SizedBox(width: AppSpacing.h6),
              _IconButtonCircle(assetPath: AssetsPath.liveIcon, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButtonCircle extends StatelessWidget {
  const _IconButtonCircle({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteBase,
      shape: CircleBorder(side: BorderSide(color: AppBorders.secondary)),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.h10),
          child: SvgPicture.asset(
            assetPath,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.neutral700,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
