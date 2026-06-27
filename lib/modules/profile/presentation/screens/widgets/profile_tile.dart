import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/text_styles.dart';

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
    final fg = textColor ?? Colors.black87;
    final iconClr = iconColor ?? Colors.black87;
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              iconWidget,
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: textStyle_16RegularBlack().copyWith(color: fg),
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
