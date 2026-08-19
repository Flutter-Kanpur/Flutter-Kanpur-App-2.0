import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Small circular icon button (white bg, thin border) for an SVG asset -
/// used for the github/figma/live link icons on both
/// `CommunityProjectPreviewCard` and the project detail screen's
/// "Project links" row.
class FkIconButtonCircle extends StatelessWidget {
  const FkIconButtonCircle({
    super.key,
    required this.assetPath,
    required this.onTap,
  });

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
