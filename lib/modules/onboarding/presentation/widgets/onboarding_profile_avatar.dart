import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingProfileAvatar extends StatelessWidget {
  const OnboardingProfileAvatar({
    super.key,
    this.localPhotoPath,
    this.networkPhotoUrl,
    this.onAddTap,
  });

  final String? localPhotoPath;
  final String? networkPhotoUrl;
  final VoidCallback? onAddTap;

  bool get _hasLocalPhoto {
    final path = localPhotoPath;
    return path != null && path.isNotEmpty && File(path).existsSync();
  }

  bool get _hasNetworkPhoto =>
      networkPhotoUrl != null && networkPhotoUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final size = 100.r;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.neutral50,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: _hasLocalPhoto
              ? Image.file(
                  File(localPhotoPath!),
                  key: ValueKey(localPhotoPath),
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                )
              : _hasNetworkPhoto
                  ? CachedNetworkImage(
                      imageUrl: networkPhotoUrl!,
                      key: ValueKey(networkPhotoUrl),
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                    )
                  : Center(
                      child: SvgPicture.asset(
                        AppAssets.avatarIcon,
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onAddTap,
            child: CircleAvatar(
              radius: 14.r,
              backgroundColor: AppColors.primary500,
              child: Icon(
                Icons.add,
                color: AppColors.whiteBase,
                size: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}