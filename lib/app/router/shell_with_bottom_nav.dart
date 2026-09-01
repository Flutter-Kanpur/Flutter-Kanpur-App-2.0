import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/gradiant_background.dart';
import '../../utils/assets_path.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

/// Persistent shell that shows the bottom nav bar on home, community, events, and profile tabs.
class ShellWithBottomNav extends StatelessWidget {
  const ShellWithBottomNav({
    super.key,
    required this.navigationShell,
    required this.state,
  });

  final StatefulNavigationShell navigationShell;
  final GoRouterState state;

  static int _selectedIndexForPath(String path) {
    if (path.startsWith('/community')) return 1;
    if (path.startsWith('/explore')) return 2;
    if (path.startsWith('/blogs')) return 3;
    if (path.startsWith('/profile')) return 4;
    return 0; // /home or default
  }

  BottomNavigationBarItem _navItem({
    required String asset,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        asset,
        colorFilter: const ColorFilter.mode(
          AppColors.neutral300,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        asset,
        colorFilter: const ColorFilter.mode(
          AppColors.primary500,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _readmeNavItem() {
    return BottomNavigationBarItem(
      icon: _ReadmeNavIcon(color: AppColors.neutral300),
      activeIcon: _ReadmeNavIcon(color: AppColors.primary500),
      label: 'ReadMe',
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = state.uri.path;
    final currentIndex = _selectedIndexForPath(path);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final hideHostBottomNav =
        isKeyboardVisible || path.startsWith(RouteNames.blogs);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: navigationShell,
        bottomNavigationBar: hideHostBottomNav
            ? null
            : Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Color(0XFFFAFCFF),
                  currentIndex: currentIndex,
                  onTap: (index) => navigationShell.goBranch(index),
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.primary500,
                  unselectedItemColor: AppColors.neutral300,
                  unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.neutral400,
                  ),
                  selectedLabelStyle: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.neutral400,
                  ),
                  items: [
                    _navItem(asset: AssetsPath.home, label: 'Home'),
                    _navItem(asset: AssetsPath.community, label: 'Community'),
                    _navItem(asset: AssetsPath.explore, label: 'Explore'),
                    _readmeNavItem(),
                    _navItem(asset: AssetsPath.profile, label: 'Profile'),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Rounded square ReadMe mark with white label drawn on the icon.
class _ReadmeNavIcon extends StatelessWidget {
  const _ReadmeNavIcon({required this.color});

  final Color color;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            AssetsPath.readme,
            width: _size,
            height: _size,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          Text(
            'ReadMe',
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.whiteBase, fontSize: 5),
          ),
        ],
      ),
    );
  }
}
