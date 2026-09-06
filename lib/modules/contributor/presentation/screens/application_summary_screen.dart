import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/application/contributor_application_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

import '../widgets/contributor_application_review_body.dart';

class ApplicationSummaryScreen extends ConsumerWidget {
  const ApplicationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(contributorApplicationDraftProvider);

    if (draft == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RouteNames.contributorApplication);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: 'contributor.applicationSummary'.tr(),
            subtitle: '',
            leading: const FkBackButton(
              fallbackPath: RouteNames.reviewApplication,
            ),
          ),
          SizedBox(height: AppSpacing.v22),
          ContributorApplicationReviewBody(draft: draft),
          SizedBox(height: AppSpacing.v22),
        ],
      ),
    );
  }
}
