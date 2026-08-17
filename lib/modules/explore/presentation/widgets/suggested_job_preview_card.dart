import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/suggested_job.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';

/// The "Saved" bookmark is local widget state seeded from the sample data -
/// there's no backend to persist it to yet.
class SuggestedJobPreviewCard extends StatefulWidget {
  const SuggestedJobPreviewCard({super.key, required this.job});

  final SuggestedJob job;

  @override
  State<SuggestedJobPreviewCard> createState() =>
      _SuggestedJobPreviewCardState();
}

class _SuggestedJobPreviewCardState extends State<SuggestedJobPreviewCard> {
  late bool _isSaved = widget.job.isSaved;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return FkCard(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Material(
                color: _isSaved ? AppColors.primary500 : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.all09,
                  side: _isSaved
                      ? BorderSide.none
                      : BorderSide(color: AppBorders.secondary),
                ),
                child: InkWell(
                  onTap: () => setState(() => _isSaved = !_isSaved),
                  borderRadius: AppRadius.all09,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.h10,
                      vertical: AppSpacing.v6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: 16,
                          color: _isSaved
                              ? AppColors.whiteBase
                              : AppColors.neutral500,
                        ),
                        SizedBox(width: AppSpacing.h4),
                        Text(
                          'Saved',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _isSaved
                                ? AppColors.whiteBase
                                : AppColors.neutral500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v8),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: job.tags
                .map(
                  (tag) =>
                      FkStatusChip(label: tag, color: AppColors.neutral500),
                )
                .toList(),
          ),
          SizedBox(height: AppSpacing.v12),
          Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.all02,
                child: CachedNetworkImage(
                  imageUrl: job.companyLogoUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    width: 32,
                    height: 32,
                    color: AppColors.neutral100,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.h8),
              Text(
                '${job.companyName} | ${job.location}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
