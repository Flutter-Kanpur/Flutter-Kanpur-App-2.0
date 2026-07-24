import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../widgets/contributor_dropdown_field.dart';
import '../widgets/contributor_info_banner.dart';
import '../widgets/contributor_profile_links.dart';
import '../widgets/contributor_skill_chip.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class ContributorApplicationScreen extends StatefulWidget {
  const ContributorApplicationScreen({super.key});

  @override
  State<ContributorApplicationScreen> createState() =>
      _ContributorApplicationScreenState();
}

class _ContributorApplicationScreenState
    extends State<ContributorApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillsFieldKey = GlobalKey<FormFieldState<List<String>>>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();

  final githubController = TextEditingController();
  final linkedinController = TextEditingController();
  final portfolioController = TextEditingController();

  final whyController = TextEditingController();

  String? currentRole;
  String? contribution;
  String? selectedSkill;
  String? experience;
  String? weeklyHours;

  final roles = [
    "Student",
    "Flutter Developer",
    "Backend Developer",
    "UI/UX Designer",
  ];

  final contributions = [
    "Community Management",
    "Events",
    "Content",
    "Development",
  ];

  final skills = ["Flutter", "UI / UX Designer", "Backend", "Firebase"];

  final experienceLevels = ["0 years", "1 year", "2 years", "3+ years"];

  final weeklyHoursList = ["2-4 hours", "4-6 hours", "6-10 hours", "10+ hours"];

  final List<String> selectedSkills = [];

  String? _requiredValidator(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return 'contributor.fieldRequired'.tr(namedArgs: {'field': field});
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredValidator(value, 'contributor.email'.tr());
    if (requiredError != null) return requiredError;

    final email = value!.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'auth.invalidEmail'.tr();
    }
    return null;
  }

  String? _urlValidator(String? value) {
    final url = value?.trim() ?? '';
    if (url.isEmpty) return null;

    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return 'onboarding.invalidLink'.tr();
    }
    return null;
  }

  String? _whyContributeValidator(String? value) {
    final requiredError = _requiredValidator(
      value,
      'contributor.whyContribute'.tr(),
    );
    if (requiredError != null) return requiredError;

    if (value!.trim().length < 20) {
      return 'contributor.whyContributeMinLength'.tr();
    }
    return null;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();

    githubController.dispose();
    linkedinController.dispose();
    portfolioController.dispose();

    whyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: FkScreen(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FkHeader(
                  title: "contributor.applicationTitle".tr(),
                  subtitle: "",
                  leading: const FkBackButton(
                    fallbackPath: RouteNames.joinContributor,
                  ),
                ),

                SizedBox(height: AppSpacing.s10),
                ContributorInfoBanner(text: "contributor.reviewDetails".tr()),

                SizedBox(height: AppSpacing.s10),

                FkTextField(
                  controller: fullNameController,
                  hint: "contributor.fullNameHint".tr(),
                  label: "contributor.fullName".tr(),
                  validator: (value) =>
                      _requiredValidator(value, 'contributor.fullName'.tr()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: AppSpacing.s08),

                FkTextField(
                  controller: emailController,
                  hint: "contributor.emailHint".tr(),
                  label: "contributor.email".tr(),
                  validator: _emailValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: AppSpacing.s08),
                ContributorDropdownField(
                  label: "contributor.currentRole".tr(),
                  value: currentRole,
                  items: roles,
                  validator: (value) => _requiredValidator(
                    value,
                    'contributor.currentRole'.tr(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      currentRole = value;
                    });
                  },
                ),

                SizedBox(height: AppSpacing.s08),

                ContributorDropdownField(
                  label: "contributor.contributionArea".tr(),
                  value: contribution,
                  items: contributions,
                  validator: (value) => _requiredValidator(
                    value,
                    'contributor.contributionArea'.tr(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      contribution = value;
                    });
                  },
                ),

                SizedBox(height: AppSpacing.s09),

                ContributorDropdownField(
                  label: "contributor.relevantSkills".tr(),
                  value: selectedSkill,
                  items: skills,
                  onChanged: (value) {
                    if (value == null) return;

                    if (!selectedSkills.contains(value)) {
                      setState(() {
                        selectedSkills.add(value);
                      });
                      _skillsFieldKey.currentState?.didChange(
                        List.of(selectedSkills),
                      );
                    }

                    selectedSkill = null;
                  },
                ),

                SizedBox(height: AppSpacing.s06),
                Wrap(
                  spacing: AppSpacing.s04,
                  runSpacing: AppSpacing.s04,
                  children: selectedSkills.map((skill) {
                    return ContributorSkillChip(
                      label: skill,
                      onDeleted: () {
                        setState(() {
                          selectedSkills.remove(skill);
                        });
                        _skillsFieldKey.currentState?.didChange(
                          List.of(selectedSkills),
                        );
                      },
                    );
                  }).toList(),
                ),

                FormField<List<String>>(
                  key: _skillsFieldKey,
                  initialValue: selectedSkills,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'onboarding.selectAtLeastOneOption'.tr();
                    }
                    return null;
                  },
                  builder: (field) {
                    if (field.errorText == null) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.only(top: AppSpacing.s04, left: AppSpacing.s02),
                      child: Text(
                        field.errorText!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warning600,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: AppSpacing.s09),
                ContributorDropdownField(
                  label: "contributor.experienceLevel".tr(),
                  value: experience,
                  items: experienceLevels,
                  validator: (value) => _requiredValidator(
                    value,
                    'contributor.experienceLevel'.tr(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      experience = value;
                    });
                  },
                ),
                SizedBox(height: AppSpacing.s09),

                ContributorDropdownField(
                  label: "contributor.weeklyContributionTime".tr(),
                  value: weeklyHours,
                  items: weeklyHoursList,
                  validator: (value) => _requiredValidator(
                    value,
                    'contributor.weeklyContributionTime'.tr(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      weeklyHours = value;
                    });
                  },
                ),

                SizedBox(height: AppSpacing.s10),
                Text(
                  "contributor.workProfileLinks".tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),

                ContributorProfileLinks(
                  githubController: githubController,
                  linkedinController: linkedinController,
                  portfolioController: portfolioController,
                  validator: _urlValidator,
                ),

                SizedBox(height: AppSpacing.s10),

                FkTextField(
                  controller: whyController,
                  hint: "contributor.whyContributeHint".tr(),
                  label: "contributor.whyContribute".tr(),
                  maxLines: 6,
                  validator: _whyContributeValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                SizedBox(height: AppSpacing.s10),
                FkPrimaryButton(
                  label: "contributor.submitApplication".tr(),
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.push(RouteNames.reviewApplication);
                    }
                  },
                ),
                SizedBox(height: AppSpacing.s10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
