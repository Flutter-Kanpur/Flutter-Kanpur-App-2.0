import 'package:flutter/material.dart';

import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/application/profile_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/domain/profile_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/add_role_experience_bottom_sheet.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/add_skills_bottom_sheet.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_error_view.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/manage_profile_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/manage_profile_section_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/problem_of_day_section.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_knp_mobile_app_v2/utils/years_of_experience.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class ManageProfileScreen extends ConsumerStatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  ConsumerState<ManageProfileScreen> createState() =>
      _ManageProfileScreenState();
}

class _ManageProfileScreenState extends ConsumerState<ManageProfileScreen> {
  // Draft state. Null means "the user has not touched this section", so the
  // loaded profile shows through — which is why nothing needs seeding from the
  // async load and there is no seed-vs-load race.
  List<String>? _draftSkills;
  int? _draftYears;

  // TODO(FKP-116): roles are never persisted — no column exists for them. They
  // live only until this screen is popped. Once `users.role_tags` (text[]) is
  // added, fall back to `profile.roleTags` here instead of an empty list and
  // pass them through to saveSkillsAndExperience.
  List<String>? _draftRoles;

  bool _isSaving = false;

  bool get _hasChanges => _draftSkills != null || _draftYears != null;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(myProfileProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.blackBase),
          ),
          title: Text(
            translate(context, "profile.manageProfile"),
            style: AppTextStyles.titleLarge,
          ),
        ),
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => FkErrorView(
            message: translate(context, 'profile.loadError'),
            onRetry: () => ref.read(myProfileProvider.notifier).refresh(),
          ),
          data: (profile) => profile == null
              ? FkEmptyView(message: translate(context, 'profile.loadError'))
              : _buildContent(profile),
        ),
      ),
    );
  }

  Widget _buildContent(ProfileUser profile) {
    final skills = _draftSkills ?? profile.skills;
    final roles = _draftRoles ?? const <String>[];
    final years = _draftYears ?? profile.yearsOfExperience;

    return SingleChildScrollView(
      padding: AppSpacing.horizontal(AppSpacing.h20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ManageProfileHeader(
            displayName: profile.displayLabel,
            designation: roles.isEmpty ? '' : roles.first,
            username: profile.handle,
            photoUrl: profile.photoUrl,
            githubUrl: profile.githubUrl,
            websiteUrl: profile.websiteUrl,
            linkedinUrl: profile.linkedinUrl,
            onEditProfile: () => context.push(RouteNames.editProfile),
          ),
          // SizedBox(height: AppSpacing.v22),
          // ProblemOfDaySection(
          //   level: 2,
          //   progress: 0.25,
          //   onViewProgress: () => context.push(RouteNames.problemOfDay),
          // ),
          SizedBox(height: AppSpacing.v22),
          ManageProfileSectionCard(
            title: translate(context, "profile.aboutMe"),
            child: Text(
              profile.hasBio
                  ? profile.bio!
                  : translate(context, 'profile.noBio'),
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral500,
                height: 1.5.sp,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.v22),
          ManageProfileSectionCard(
            title: translate(context, "profile.roleExperience"),
            value: yearsOfExperienceLabelFor(context, years),
            tags: roles,
            onEdit: () => _showRoleExperienceSheet(roles, years),
          ),
          SizedBox(height: AppSpacing.v22),
          ManageProfileSectionCard(
            title: translate(context, "profile.skills"),
            tags: skills,
            // The card renders nothing for an empty tag list, which reads as a
            // broken section rather than an empty one.
            child: skills.isEmpty
                ? Text(
                    translate(context, 'profile.noSkills'),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.neutral500,
                    ),
                  )
                : null,
            onEdit: () => _showSkillsSheet(skills),
          ),
          SizedBox(height: AppSpacing.v22),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: GradientButton(
                  onTap: _isSaving ? () {} : () => _save(profile),
                  isLoading: _isSaving,
                  text: translate(context, "profile.saveChanges"),
                  textStyle: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.whiteBase,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  // Draft state lives on this State, so popping discards it.
                  onPressed: _isSaving ? null : () => context.pop(),
                  child: Text(
                    translate(context, "profile.cancel"),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.blackBase,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v22),
        ],
      ),
    );
  }

  /// Commits the draft.
  ///
  /// Uses the awaited result rather than `ref.listen` on the action controller:
  /// that controller is shared with Edit Profile, which is pushed on top of
  /// this screen while it stays mounted, so a listener here would also fire —
  /// and pop this screen — when Edit Profile saves.
  Future<void> _save(ProfileUser profile) async {
    if (!_hasChanges) {
      context.pop();
      return;
    }

    setState(() => _isSaving = true);
    final saved = await ref
        .read(profileActionControllerProvider.notifier)
        .saveSkillsAndExperience(
          skills: _draftSkills ?? profile.skills,
          yearsOfExperience: _draftYears ?? profile.yearsOfExperience,
          current: profile,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (saved) {
      _showSnack('profile.updateSuccess', AppColors.success600);
      context.pop();
    } else {
      _showSnack('profile.updateError', AppColors.warning600);
    }
  }

  void _showSnack(String key, Color background) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(translate(context, key)),
          backgroundColor: background,
        ),
      );
  }

  void _showSkillsSheet(List<String> current) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddSkillsBottomSheet(
        initialSkills: current,
        onSave: (skills) => setState(() => _draftSkills = skills),
      ),
    );
  }

  void _showRoleExperienceSheet(List<String> currentRoles, int currentYears) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddRoleExperienceBottomSheet(
        initialRoles: currentRoles,
        initialYearsOfExperience: currentYears,
        onSave: (roles, years) => setState(() {
          _draftRoles = roles;
          if (years != null) _draftYears = years;
        }),
      ),
    );
  }
}
