import 'package:flutter/material.dart';
import '../../../../../utils/translate.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/gradiant_background.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/text_styles.dart';
// import '../../domain/entities/profile_entity.dart';
import '../../../../../shared/widgets/manage_profile_header.dart';
import '../../../../../shared/widgets/manage_profile_section_card.dart';
import '../../../../../shared/widgets/problem_of_day_section.dart';
import '../../../../../shared/widgets/add_role_experience_bottom_sheet.dart';
import '../../../../../shared/widgets/add_skills_bottom_sheet.dart';


class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class MockProfile {
  final String github;
  final String website;
  final String linkedin;

  const MockProfile({
    required this.github,
    required this.website,
    required this.linkedin,
  });
}
class _ManageProfileScreenState extends State<ManageProfileScreen> {
  // ProfileEntity? _draftProfile;

// Temporary mock data - remove when backend is integrated
  final String displayName = ProfileConstants.displayName;
  final String designation = ProfileConstants.designation;
  final String username = ProfileConstants.username;
  final String photoUrl = ProfileConstants.photoUrl;
  final String githubUrl = ProfileConstants.githubUrl;
  final String websiteUrl = ProfileConstants.websiteUrl;
  final String linkedinUrl = ProfileConstants.linkedinUrl;
  final String about = ProfileConstants.about;
  final String yearsOfExp = ProfileConstants.yearsOfExperience;

  final List<String> roleTags = ProfileConstants.roleTags;
  final List<String> skills = ProfileConstants.skills;

  final bool isLoading = ProfileConstants.isLoading;

  final int problemLevel = ProfileConstants.problemLevel;
  final double problemProgress = ProfileConstants.problemProgress;

  final MockProfile profile = const MockProfile(
    github: ProfileConstants.githubUrl,
    website: ProfileConstants.websiteUrl,
    linkedin: ProfileConstants.linkedinUrl,
  );


  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 22.sp,
              color: const Color(0xFF161616),
            ),
          ),
          title: Text(
            translate(context, "profile.manageProfile"),
            style: textStyle_16MediumBlack().copyWith(fontSize: 18.sp),
          ),
        ),
        body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ManageProfileHeader(
                        displayName: displayName,
                        designation: designation,
                        username: username,
                        photoUrl: photoUrl,
                        githubUrl: profile?.github,
                        websiteUrl: profile?.website,
                        linkedinUrl: profile?.linkedin,
                        onEditProfile: () =>
                            context.push('/profile/edit-profile'),
                      ),
                      SizedBox(height: 24.h),
                      ProblemOfDaySection(
                        level: 2,
                        progress: 0.25,
                        onViewProgress: () {},
                      ),
                      SizedBox(height: 24.h),
                      ManageProfileSectionCard(
                        title: translate(context, "profile.aboutMe"),
                        child: Text(
                          about ?? '',
                          style: textStyle_16RegularBlack().copyWith(
                            color: AppColors.subtitleTextDarkGrey,
                            height: 1.5,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ManageProfileSectionCard(
                        title: translate(context, "profile.roleExperience"),
                        value: yearsOfExp,
                        tags: roleTags,
                        onEdit: () => profile != null
                            ? _showAddRoleExperienceBottomSheet(context, profile)
                            : null,
                      ),
                      SizedBox(height: 24.h),
                      ManageProfileSectionCard(
                        title: translate(context, "profile.skills"),
                        tags: skills,
                        onEdit: () => profile != null
                            ? _showAddSkillsBottomSheet(context, profile)
                            : null,
                      ),
                      SizedBox(height: 32.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GradientButton(
                              onTap: () {
                                // if (_draftProfile != null) {
                                //   context
                                //       .read<ProfileBloc>()
                                //       .add(UpdateProfile(_draftProfile!));
                                // } else {
                                //   context.pop();
                                // }
                                  context.pop();
                              },
                              isLoading: isLoading,
                              text: translate(context, "profile.saveChanges"),
                              textStyle: textStyle_16MediumBlack().copyWith(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                translate(context, "profile.cancel"),
                                style: textStyle_16MediumBlack().copyWith(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF161616),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
    );
  }

  void _showAddSkillsBottomSheet(BuildContext context,  profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSkillsBottomSheet(
        // profile: profile,
        onSave: (newSkills) {
          setState(() {
            // _draftProfile = profile.copyWith(skills: newSkills);
          });
        },
      ),
    );
  }

  void _showAddRoleExperienceBottomSheet(
      BuildContext context,  profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoleExperienceBottomSheet(
        // profile: profile,
        onSave: (newRoles, newExp) {
          setState(() {
            // _draftProfile = profile.copyWith(
            //   roleTags: newRoles,
            //   yearsOfExperience: newExp,
            // );
          });
        },
      ),
    );
  }
}

// have to remove this when integrating backend

class ProfileConstants {
  static const String displayName = 'Hariom Vishwakarma';
  static const String designation = 'Flutter Developer';
  static const String username = '@hariom';

  static const String photoUrl =
      'https://your-image-url.com/profile.jpg';

  static const String githubUrl =
      'https://github.com/hariom';

  static const String websiteUrl =
      'https://hariom.dev';

  static const String linkedinUrl =
      'https://linkedin.com/in/hariom';

  static const String about =
      'Passionate Flutter developer with experience in mobile app development, NFC integrations, widgets, and scalable architecture.';

  static const String yearsOfExperience = '1.5 Years';

  static const List<String> roleTags = [
    'Flutter Developer',
    'Mobile Developer',
  ];

  static const List<String> skills = [
    'Flutter',
    'Dart',
    'Firebase',
    'Git',
    'REST API',
    'Figma',
    'Android',
    'iOS',
  ];

  static const int problemLevel = 2;
  static const double problemProgress = 0.25;

  static const bool isLoading = false;
}