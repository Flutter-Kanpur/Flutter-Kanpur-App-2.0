import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';

/// Badge artwork from `badges.icon_url` (uploaded via the admin dashboard).
/// Falls back to a default badge when there's no URL or it fails to load.
/// [locked] renders it greyscale and faded, as in the locked badge cards.
class BadgeIcon extends StatelessWidget {
  const BadgeIcon({
    super.key,
    required this.iconUrl,
    required this.size,
    this.locked = false,
  });

  final String? iconUrl;
  final double size;
  final bool locked;

  static const _greyscale = ColorFilter.matrix([
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    final url = iconUrl;
    final Widget art = url == null
        ? _DefaultBadgeArt(size: size)
        : CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            fit: BoxFit.contain,
            placeholder: (_, _) =>
                FkSkeletonBlock(width: size, height: size, radius: size * 0.28),
            errorWidget: (_, _, _) => _DefaultBadgeArt(size: size),
          );

    if (!locked) return SizedBox.square(dimension: size, child: art);

    return SizedBox.square(
      dimension: size,
      child: Opacity(
        opacity: 0.55,
        child: ColorFiltered(colorFilter: _greyscale, child: art),
      ),
    );
  }
}

class _DefaultBadgeArt extends StatelessWidget {
  const _DefaultBadgeArt({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AppColors.primary200, width: size * 0.05),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary400, AppColors.primary800],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary500.withValues(alpha: 0.25),
            blurRadius: size * 0.15,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      child: Icon(
        Icons.workspace_premium_rounded,
        color: AppColors.whiteBase,
        size: size * 0.55,
      ),
    );
  }
}
