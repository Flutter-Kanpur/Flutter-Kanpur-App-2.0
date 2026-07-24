import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    this.icon,
    this.iconSvgPath,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  }) : assert(icon != null || iconSvgPath != null, 'Provide either icon or iconSvgPath');

  final IconData? icon;
  final String? iconSvgPath;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? AppColors.blackBase;
    final iconClr = iconColor ?? AppColors.blackBase;
    final size = 24.sp;

    Widget iconWidget;
    if (iconSvgPath != null && iconSvgPath!.isNotEmpty) {
      iconWidget = SvgPicture.asset(
        iconSvgPath!,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(iconClr, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(icon, size: size, color: iconClr);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.symmetric(horizontal: AppSpacing.s09, vertical: AppSpacing.s06),
          child: Row(
            children: [
              iconWidget,
              SizedBox(width: AppSpacing.s04),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(color: fg),
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 24.sp, color: iconClr),
            ],
          ),
        ),
      ),
    );
  }
}
