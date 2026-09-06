import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/contributor_application_review_body.dart';
import '../widgets/contributor_info_banner.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class ReviewApplicationScreen extends ConsumerWidget {
  const ReviewApplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(contributorApplicationDraftProvider);

    if (draft == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RouteNames.contributorApplication);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: FkScreen(
        children: [
          FkHeader(
            title: 'contributor.reviewYourApplication'.tr(),
            subtitle: '',
            leading: const FkBackButton(
              fallbackPath: RouteNames.contributorApplication,
            ),
          ),
          SizedBox(height: AppSpacing.v22),
          ContributorInfoBanner(
            text: 'contributor.reviewApplicationBanner'.tr(),
          ),
          SizedBox(height: AppSpacing.v22),
          ContributorApplicationReviewBody(draft: draft),
          SizedBox(height: AppSpacing.v22),
          FkPrimaryButton(
            label: 'contributor.submitApplication'.tr(),
            onPressed: () =>
                context.push(RouteNames.applicationAlreadySubmitted),
          ),
          SizedBox(height: AppSpacing.v12),
          Center(
            child: TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(RouteNames.contributorApplication);
                }
              },
              child: Text('contributor.editDetails'.tr()),
            ),
          ),
          SizedBox(height: AppSpacing.v22),
        ],
      ),
    );
  }
}
