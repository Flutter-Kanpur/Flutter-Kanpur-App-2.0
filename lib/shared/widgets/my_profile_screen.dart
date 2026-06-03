import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// import '../../../common_widgets/gradiant_background.dart';
// import '../../../services/remote_config_service.dart';
import '../../app/router/route_names.dart';
import '../../utils/assets_path.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
// import '../../auth/presentation/bloc/auth_bloc.dart';
// import '../../auth/presentation/bloc/auth_event.dart';
// import '../../auth/presentation/bloc/auth_state.dart';
import 'profile_header.dart';
import 'profile_section_block.dart';
import 'profile_tile.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  bool _canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context) {
    String displayName = 'Hari om';
    String username = 'hariomfk';
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: _canPop(context)
              ? IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          title: Text(
            'My Profile',
            style: textStyle_16RegularBlack().copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileHeader(
                    displayName: displayName,
                    username: username,
                    // photoUrl: photoUrl,
                  ),
                  ProfileSectionBlock(
                    title: 'Account',
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileManageProfile, title: 'Manage Profile', onTap: () => context.push(RouteNames.manage_profile)),
                      ProfileTile(iconSvgPath: AssetsPath.profileLoginSecurity, title: 'Login & Security', onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileNotifications, title: 'Notifications', onTap: () {}),
                    ],
                  ),
                  ProfileSectionBlock(
                    title: 'My Activity',
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileMyEvents, title: 'My Events', onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileMyContests, title: 'My Contests', onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileProblemOfDay, title: 'Problem of the Day', onTap: () {}),
                    ],
                  ),
                  // if (showCommunitySection)
                    ProfileSectionBlock(
                      title: 'Community',
                      tiles: [
                        ProfileTile(
                          iconSvgPath: AssetsPath.profileMyContributions,
                          title: 'My Contributions',
                          onTap: () => context.push('/profile/my-contributions'),
                        ),
                        ProfileTile(
                          iconSvgPath: AssetsPath.profileJoinAsContributor,
                          title: 'Join as a Contributor',
                          onTap: () => context.push('/profile/join'),
                        ),
                        ProfileTile(
                          iconSvgPath: AssetsPath.profileCommunityGuidelines,
                          title: 'Community Guidelines',
                          onTap: () => context.push('/profile/community-guidelines'),
                        ),
                      ],
                    ),
                  ProfileSectionBlock(
                    title: 'Achievements',
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileYourBadges, title: 'Your Badges', onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileYourRank, title: 'Your Rank', onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileLeaderboard, title: 'Leaderboard', onTap: () {}),
                    ],
                  ),
                  ProfileSectionBlock(
                    title: 'Support',
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileHelpCenter, title: 'Help Center', onTap: () =>context.push('/profile/help-center')),
                      ProfileTile(
                        iconSvgPath: AssetsPath.profileContactCommunity,
                        title: 'Contact Community Team',
                        onTap: () =>
                            context.push('/profile/contact-community-team'),
                      ),
                      ProfileTile(iconSvgPath: AssetsPath.profileReportIssue, title: 'Report an Issue', onTap: () => context.push('/profile/report-an-issue')),
                    ],
                  ),
                  ProfileSectionBlock(
                    title: 'About & Legal',
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileAboutFlutterKanpur, title: 'About Flutter Kanpur', onTap: () => context.push('/profile/about-flutter-kanpur')),
                      ProfileTile(iconSvgPath: AssetsPath.profilePrivacyPolicy, title: 'Privacy Policy', onTap: () => context.push('/profile/privacy-policy')),
                      ProfileTile(iconSvgPath: AssetsPath.profileTermsOfUse, title: 'Terms of Use', onTap: () => context.push('/profile/terms-of-use')),
                    ],
                  ),
                  ProfileSectionBlock(
                    title: 'Account Actions',
                    tiles: [
                      ProfileTile(
                        iconSvgPath: AssetsPath.profileLogout,
                        title: 'Log out',
                        textColor: AppColors.errorColor,
                        iconColor: AppColors.errorColor,
                        onTap: () => _showLogoutDialog(context),
                      ),
                      ProfileTile(
                        iconSvgPath: AssetsPath.profileDeleteAccount,
                        title: 'Delete account',
                        textColor: AppColors.errorColor,
                        iconColor: AppColors.errorColor,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
        ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // context.read<AuthBloc>().add(SignOutRequested());
            },
            child: const Text('Log out', style: TextStyle(color: AppColors.errorColor)),
          ),
        ],
      ),
    );
  }
}
