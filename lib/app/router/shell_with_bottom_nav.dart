import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/gradiant_background.dart';
import '../../utils/assets_path.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

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
    if (path.startsWith('/events')) return 2;
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
          AppColors.unselectedNavBarIconColor,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        asset,
        colorFilter: const ColorFilter.mode(
          AppColors.selectedNavBarIconColor,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = state.uri.path;
    final currentIndex = _selectedIndexForPath(path);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: navigationShell,
        bottomNavigationBar: isKeyboardVisible
            ? null
            : Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: BottomNavigationBar(
                  backgroundColor: AppColors.navBarBackgroundColorV2,
                  currentIndex: currentIndex,
                  onTap: (index) => navigationShell.goBranch(index),
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.selectedNavBarIconColor,
                  unselectedItemColor: AppColors.unselectedNavBarIconColor,
                  unselectedLabelStyle: textStyle_12MediumGrey(),
                  selectedLabelStyle: textStyle_12MediumGrey(),
                  items: [
                    _navItem(asset: AssetsPath.home, label: 'Home'),
                    _navItem(asset: AssetsPath.community, label: 'Community'),
                    _navItem(asset: AssetsPath.explore, label: 'Explore'),
                    _navItem(asset: AssetsPath.explore, label: 'Blogs'),
                    _navItem(asset: AssetsPath.profile, label: 'Profile'),
                  ],
                ),
              ),
      ),
    );
  }
}
