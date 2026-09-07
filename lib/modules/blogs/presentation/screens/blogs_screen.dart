import 'dart:async';

import 'package:Readme/core/utils/assets_path.dart' as readme_assets;
import 'package:Readme/core/utils/draft_storage.dart';
import 'package:Readme/features/communities/presentation/pages/communities_screen.dart';
import 'package:Readme/features/create_blog_page/presentation/pages/my_drafts_screen.dart';
import 'package:Readme/features/home_page/presentation/pages/home_screen.dart'
    as readme;
import 'package:Readme/features/profile_page/presentation/screens/profile_screen.dart'
    as readme;
import 'package:Readme/features/search/presentation/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/blogs/data/readme_auth_bridge.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Hosts the ReadMe blogs experience with ReadMe's bottom nav, plus a leading
/// "Home" control that exits back to the Flutter Kanpur main app.
class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  /// Matches ReadMe shell branches: home, explore, community, profile, drafts.
  static const int _draftsIndex = 4;

  int _currentIndex = 0;
  bool _hasDraft = false;
  bool _readmeSessionReady = false;
  bool _readmeAuthFailed = false;
  late final StreamSubscription<AuthState> _hostAuthSub;

  @override
  void initState() {
    super.initState();
    _bootstrapReadmeSession();
    _hostAuthSub = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) async {
      if (data.event == AuthChangeEvent.signedIn) {
        setState(() {
          _readmeSessionReady = false;
          _readmeAuthFailed = false;
        });
        final ok = await ReadmeAuthBridge.ensureSignedIn(force: true);
        if (mounted) {
          setState(() {
            _readmeSessionReady = true;
            _readmeAuthFailed = !ok &&
                Supabase.instance.client.auth.currentSession != null;
          });
        }
      } else if (data.event == AuthChangeEvent.signedOut) {
        await ReadmeAuthBridge.signOut();
        if (mounted) {
          setState(() {
            _readmeSessionReady = true;
            _readmeAuthFailed = false;
          });
        }
      }
    });
  }

  Future<void> _bootstrapReadmeSession() async {
    final hostSignedIn =
        Supabase.instance.client.auth.currentSession != null;
    final ok = await ReadmeAuthBridge.ensureSignedIn();
    if (!mounted) return;
    setState(() {
      _readmeSessionReady = true;
      _readmeAuthFailed = hostSignedIn && !ok;
    });
    _refreshDraftFlag();
  }

  @override
  void dispose() {
    _hostAuthSub.cancel();
    super.dispose();
  }

  Future<void> _refreshDraftFlag() async {
    final hasDraft = await DraftStorage.hasSavedDraft();
    if (mounted) setState(() => _hasDraft = hasDraft);
  }

  void _goTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _refreshDraftFlag();
  }

  void _exitToHostHome() {
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: !_readmeSessionReady
          ? const Center(child: CircularProgressIndicator())
          : _readmeAuthFailed
          ? _ReadmeAuthFailedView(onRetry: _bootstrapReadmeSession)
          : IndexedStack(
              index: _currentIndex,
              children: const [
                readme.HomeScreen(),
                SearchScreen(),
                CommunitiesScreen(),
                readme.ProfileScreen(),
                MyDraftsScreen(),
              ],
            ),
      bottomNavigationBar: isKeyboardVisible
          ? null
          : _ReadmeHostBottomNav(
              currentIndex: _currentIndex,
              hasDraft: _hasDraft,
              isDraftActive: _currentIndex == _draftsIndex,
              onExitToHostHome: _exitToHostHome,
              onTap: _goTab,
              onDraftTap: () => _goTab(_draftsIndex),
            ),
    );
  }
}

class _ReadmeAuthFailedView extends StatelessWidget {
  const _ReadmeAuthFailedView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.all(AppSpacing.h22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Could not connect your account to ReadMe.',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.blackBase,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v12),
            Text(
              'Check README_SYNC_SESSION_URL and ReadMe Supabase secrets, '
              'then try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v20),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

/// Matches [ShellWithBottomNav] icon size/colors.
class _NavTokens {
  static const double iconSize = 24;
  static const Color selected = AppColors.primary500;
  static const Color unselected = AppColors.neutral300;

  static TextStyle labelStyle({required bool isSelected}) =>
      AppTextStyles.labelMedium.copyWith(
        color: isSelected ? selected : unselected,
      );
}

/// ReadMe bottom nav with a leading host "Home" exit + divider
/// (Instamart-style: Home | mini-app tabs).
class _ReadmeHostBottomNav extends StatelessWidget {
  const _ReadmeHostBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onDraftTap,
    required this.onExitToHostHome,
    this.hasDraft = false,
    this.isDraftActive = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onDraftTap;
  final VoidCallback onExitToHostHome;
  final bool hasDraft;
  final bool isDraftActive;

  static const _items = [
    _NavItemData(label: 'Home', assetPath: readme_assets.AssetsPath.homeNaveIcon),
    _NavItemData(label: 'Explore', assetPath: readme_assets.AssetsPath.exploreIcon),
    _NavItemData(
      label: 'Community',
      assetPath: readme_assets.AssetsPath.communityIcon,
    ),
    _NavItemData(
      label: 'Profile',
      assetPath: readme_assets.AssetsPath.profileNaveIcon,
    ),
  ];

  /// Maps visual slot index (0..4 in the ReadMe row) → branch index.
  /// Slot 2 is the Draft CTA and is handled separately.
  int _branchForSlot(int slot) {
    if (slot < 2) return slot;
    return slot - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteBase,
      child: SafeArea(
        top: false,
        // Match host [BottomNavigationBar] content height (excludes safe inset).
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HostHomeExit(onTap: onExitToHostHome),
              Center(
                child: Container(
                  width: 1,
                  height: _NavTokens.iconSize + 12,
                  margin: EdgeInsets.only(right: AppSpacing.h4),
                  color: AppColors.neutral200,
                ),
              ),
              for (var i = 0; i < 5; i++)
                if (i == 2)
                  Expanded(
                    child: _DraftCtaButton(
                      onTap: onDraftTap,
                      hasDraft: hasDraft,
                      isActive: isDraftActive,
                    ),
                  )
                else
                  Expanded(
                    child: _NavItem(
                      data: _items[_branchForSlot(i)],
                      isSelected: currentIndex == _branchForSlot(i),
                      onTap: () => onTap(_branchForSlot(i)),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HostHomeExit extends StatelessWidget {
  const _HostHomeExit({required this.onTap});

  final VoidCallback onTap;

  /// Smaller than tab icons so the longer "Back to Home" label still fits.
  static const double _exitIconSize = 22;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: _NavTokens.iconSize,
                width: _exitIconSize,
                child: Center(
                  child: Container(
                    width: _exitIconSize,
                    height: _exitIconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _NavTokens.unselected,
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 11,
                      color: _NavTokens.unselected,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Back',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: _NavTokens.labelStyle(isSelected: false)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.label, required this.assetPath});

  final String label;
  final String assetPath;
}

class _NavBarSlot extends StatelessWidget {
  const _NavBarSlot({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _NavTokens.iconSize,
              width: _NavTokens.iconSize,
              child: Center(child: icon),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _NavTokens.labelStyle(isSelected: isSelected),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftCtaButton extends StatelessWidget {
  const _DraftCtaButton({
    required this.onTap,
    required this.hasDraft,
    this.isActive = false,
  });

  final VoidCallback onTap;
  final bool hasDraft;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _NavTokens.selected : _NavTokens.unselected;

    return _NavBarSlot(
      onTap: onTap,
      label: 'Draft',
      isSelected: isActive,
      icon: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            readme_assets.AssetsPath.draftIcon,
            package: readme_assets.AssetsPath.package,
            width: _NavTokens.iconSize,
            height: _NavTokens.iconSize,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          if (hasDraft)
            Positioned(
              top: -2,
              right: -4,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _NavTokens.selected,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.whiteBase, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _NavTokens.selected : _NavTokens.unselected;

    return _NavBarSlot(
      onTap: onTap,
      label: data.label,
      isSelected: isSelected,
      icon: SvgPicture.asset(
        data.assetPath,
        package: readme_assets.AssetsPath.package,
        width: _NavTokens.iconSize,
        height: _NavTokens.iconSize,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
