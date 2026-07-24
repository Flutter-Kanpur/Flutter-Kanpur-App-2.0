import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommunityAskBanner extends StatelessWidget {
  const CommunityAskBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadius.all06,
        child: AspectRatio(
          aspectRatio: 346 / 187,
          child: SvgPicture.asset(
            AssetsPath.communityTopContainer,
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}
