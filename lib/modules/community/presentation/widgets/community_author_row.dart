import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

/// Avatar + name + timestamp, shared by the discussion card, the detail
/// header and the answer cards.
class CommunityAuthorRow extends StatelessWidget {
  const CommunityAuthorRow({
    super.key,
    required this.name,
    required this.subtitle,
    this.photoUrl,
    this.radius = 18,
    this.trailing,
  });

  final String name;
  final String subtitle;
  final String? photoUrl;
  final double radius;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommunityAvatar(name: name, photoUrl: photoUrl, radius: radius),
        SizedBox(width: AppSpacing.h10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
                ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Avatar that falls back to the first initial when there is no photo, and
/// again if the photo fails to load.
class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.radius = 18,
  });

  final String name;
  final String? photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary100,
      foregroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
      // Rendered underneath the image, so a broken URL degrades to the initial
      // instead of an empty circle.
      child: Text(
        initial,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary700,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
