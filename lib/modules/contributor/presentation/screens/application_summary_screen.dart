import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/domain/contributor_application_draft.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/contributor_application_review_body.dart';

class ApplicationSummaryScreen extends ConsumerWidget {
  const ApplicationSummaryScreen({super.key});

  static const ContributorApplicationDraft _fallbackDraft =
      ContributorApplicationDraft(
    fullName: 'Angelica Singh',
    email: 'angie.work@gmail.com',
    currentRole: 'UI/UX Designer',
    contributionArea: 'Design System',
    skills: ['Figma', 'UI/UX Designer', 'Flutter'],
    experienceLevel: '2 years',
    weeklyHours: '2-4 hours',
    githubUrl: 'https://github.com/angelica-singh-04',
    websiteUrl: 'https://angelica.works',
    linkedinUrl: 'https://linkedin.com/angelica.works',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(myContributorApplicationProvider).value;
    final draft = ref.watch(contributorApplicationDraftProvider) ??
        (appData != null
            ? ContributorApplicationDraft.fromSupabaseMap(appData)
            : _fallbackDraft);

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: FkScreen(
        children: [
          SizedBox(height: AppSpacing.v10),

          /// Top App Bar / Header
          Row(
            children: [
              const FkBackButton(
                fallbackPath: RouteNames.applicationUnderReview,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'contributor.applicationSummary'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral950,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balances the 48px IconButton
            ],
          ),

          SizedBox(height: AppSpacing.v20),

          /// Application Summary Card Container
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h18,
              vertical: AppSpacing.v20,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteBase,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppBorders.secondary),
            ),
            child: ContributorApplicationReviewBody(draft: draft),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
