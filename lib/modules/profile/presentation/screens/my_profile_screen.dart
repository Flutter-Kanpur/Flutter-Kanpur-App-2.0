import 'package:Readme/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/navigation_provider.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/application/profile_provider.dart';
import '../../../../utils/assets_path.dart';
import '../../../../utils/translate.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_section_block.dart';
import 'widgets/profile_tile.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_confirm_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_knp_mobile_app_v2/core/storage/app_prefs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/repositories/user_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  bool _canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
  forceMaterialTransparency: true,
  centerTitle: true,
  backgroundColor: Colors.transparent,
  elevation: 0,
  scrolledUnderElevation: 0,
  surfaceTintColor: Colors.transparent,
  shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: _canPop(context)
              ? IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
          title: Text(
 'profile.myProfileTitle'.tr(),
  style: AppTextStyles.titleMedium.copyWith(
    color: AppColors.blackBase,
    fontWeight: FontWeight.w600,
  ),
),
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(myProfileProvider.notifier).refresh(),
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 profileAsync.when(
  loading: () => const ProfileHeader(
    displayName: '',
    username: '',
  ),
  error: (_, _) => ProfileHeader(
    displayName: translate(context, 'profile.loadError'),
    username: '',
  ),
  data: (profile) => ProfileHeader(
    displayName: profile?.displayLabel ?? '',
    username: profile?.handle ?? '',
    photoUrl: profile?.photoUrl,
    onEditProfile: () =>
        context.push(RouteNames.editProfile),
  ),
),
                  ProfileSectionBlock(
  title: 'profile.sectionAccount'.tr(),
  tiles: [
    ProfileTile(iconSvgPath: AssetsPath.profileManageProfile, title: 'profile.manageProfile'.tr(), onTap: () => context.push('/profile/manage-profile')),
    ProfileTile(iconSvgPath: AssetsPath.profileLoginSecurity, title: 'profile.loginAndSecurity'.tr(), onTap: () {}),
    ProfileTile(iconSvgPath: AssetsPath.profileNotifications, title: 'profile.notifications'.tr(), onTap: () {}),
  ],
),
                 ProfileSectionBlock(
  title: 'profile.sectionMyActivity'.tr(),
  tiles: [
    ProfileTile(iconSvgPath: AssetsPath.profileMyEvents, title: 'profile.myEvents'.tr(), onTap: () {}),
    ProfileTile(iconSvgPath: AssetsPath.profileMyContests, title: 'profile.myContests'.tr(), onTap: () {}),
    ProfileTile(iconSvgPath: AssetsPath.profileProblemOfDay, title: 'profile.problemOfDay'.tr(), onTap: () {}),
  ],
),
                    ProfileSectionBlock(
                     title: 'profile.sectionCommunity'.tr(),
                      tiles: [
                        ProfileTile(
                          iconSvgPath: AssetsPath.profileMyContributions,
                         title: 'profile.myContributions'.tr(),
                          onTap: () =>
                              context.push(RouteNames.myContributions),
                        ),
                        ProfileTile(
                          iconSvgPath: AssetsPath.profileJoinAsContributor,
                          title: 'profile.joinAsContributor'.tr(),
                          onTap: () => context.push(RouteNames.joinContributor),
                        ),
                        ProfileTile(
                          iconSvgPath: AssetsPath.profileCommunityGuidelines,
                         title: 'profile.communityGuidelines'.tr(),
                          onTap: () => context.push(RouteNames.communityGuidelines),
                        ),
                      ],
                    ),
                  ProfileSectionBlock(
                   title: 'profile.sectionAchievements'.tr(),
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileYourBadges, title: 'profile.yourBadges'.tr(), onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileYourRank, title: 'profile.yourRank'.tr(), onTap: () {}),
                      ProfileTile(iconSvgPath: AssetsPath.profileLeaderboard, title: 'profile.leaderboard'.tr(), onTap: () {}),
                    ],
                  ),
                  ProfileSectionBlock(
                   title: 'profile.sectionSupport'.tr(),
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileHelpCenter, title: 'profile.helpCenter'.tr(), onTap: () => context.push(RouteNames.helpCenter)),
                      ProfileTile(
                        iconSvgPath: AssetsPath.profileContactCommunity,
                       title: 'profile.contactCommunity'.tr(),
                        onTap: () =>
                            context.push(RouteNames.contactCommunityTeam),
                      ),
                      ProfileTile(iconSvgPath: AssetsPath.profileReportIssue, title: 'profile.reportIssue'.tr(), onTap: () => context.push(RouteNames.reportAnIssue)),
                    ],
                  ),
                  ProfileSectionBlock(
                   title: 'profile.sectionAboutLegal'.tr(),
                    tiles: [
                      ProfileTile(iconSvgPath: AssetsPath.profileAboutFlutterKanpur, title: 'profile.aboutFlutterKanpur'.tr(), onTap: () => context.push(RouteNames.aboutFlutterKanpur)),
                      ProfileTile(iconSvgPath: AssetsPath.profilePrivacyPolicy, title: 'profile.privacyPolicy'.tr(), onTap: () => context.push(RouteNames.privacyPolicy)),
                      ProfileTile(iconSvgPath: AssetsPath.profileTermsOfUse, title: 'profile.termsOfUse'.tr(), onTap: () => context.push(RouteNames.termsOfUse)),
                    ],
                  ),
                  ProfileSectionBlock(
                   title: 'profile.sectionAccountActions'.tr(),
                    tiles: [
                      ProfileTile(
                        iconSvgPath: AssetsPath.profileLogout,
                       title: 'profile.logout'.tr(),
                        textColor: AppColors.warning600,
                        iconColor: AppColors.warning600,
                        onTap: () => _showLogoutDialog(context, ref),
                      ),
                      ProfileTile(
                        iconSvgPath: AssetsPath.profileDeleteAccount,
                       title: 'profile.deleteAccount'.tr(),
                        textColor: AppColors.warning600,
                        iconColor: AppColors.warning600,
                        onTap: () => _showDeleteAccountDialog(context, ref),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.v22),
                ],
              ),
            ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  FkConfirmDialog.show(
    context,
    title: 'profile.logoutTitle'.tr(),
    message: 'profile.logoutMessage'.tr(),
    confirmLabel: 'profile.logout'.tr(),
    cancelLabel: 'profile.cancel'.tr(),
    confirmColor: AppColors.warning600,
    messageColor: AppColors.neutral400,
    blurBarrier: true,
    onConfirm: () async {
      final logoutSuccess = await _logout(ref);
      if (!context.mounted) return;

      if (logoutSuccess) {
        context.go(RouteNames.authLanding);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('profile.logoutFailed'.tr()),
            backgroundColor: AppColors.warning600,
          ),
        );
      }
    },
  );
}

  Future<bool> _logout(WidgetRef ref) async {
    try {
      await ref.read(signOutProvider)();
      ref.invalidate(currentUserProvider);
      ref.invalidate(nextRouteProvider);
      ref.invalidate(splashRouteProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  FkConfirmDialog.show(
    context,
    title: 'profile.deleteAccountTitle'.tr(),
    message: 'profile.deleteAccountMessage'.tr(),
    confirmLabel: 'profile.deleteAccount'.tr(),
    cancelLabel: 'profile.cancel'.tr(),
    confirmColor: AppColors.warning600,
    messageColor: AppColors.neutral400,
    blurBarrier: true,
    onConfirm: () async {
      final ok = await _deleteAccount(ref);
      if (!context.mounted) return;
      if (ok) {
        context.go(RouteNames.authLanding);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('profile.deleteAccountFailed'.tr()),
            backgroundColor: AppColors.warning600,
          ),
        );
      }
    },
  );
}

Future<bool> _deleteAccount(WidgetRef ref) async {
  try {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return false;

    final result = await UserRepository().deleteUser(uid);
    if (!result.isSuccess) return false;

    await AppPrefs.clearOnboardingDraft();
    await ref.read(signOutProvider)();
    ref.invalidate(currentUserProvider);
    ref.invalidate(nextRouteProvider);
    ref.invalidate(splashRouteProvider);
    return true;
  } catch (_) {
    return false;
  }
}
}

