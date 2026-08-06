import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_result_screen.dart';

class ProjectSubmittedScreen extends StatelessWidget {
  const ProjectSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkResultScreen(
      title: 'Project submitted',
      message:
          'Thanks for sharing your project. Our team will review it and notify '
          'you once it is approved.',
      icon: Icons.check_rounded,
      color: AppColors.primary500,
      buttonLabel: 'View my projects',
      onPressed: () => context.go(RouteNames.communityProjects),
      secondaryLabel: 'Back to community',
      onSecondaryPressed: () => context.go(RouteNames.community),
    );
  }
}

class QuestionPostedScreen extends StatelessWidget {
  const QuestionPostedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkResultScreen(
      title: 'Question posted',
      message: 'Your question is now visible to the community.',
      icon: Icons.check_rounded,
      color: AppColors.primary500,
      buttonIcon: Icons.visibility_outlined,
      buttonLabel: 'View discussion',
      onPressed: () => context.go(RouteNames.communityDiscussions),
      secondaryLabel: 'Post another question',
      onSecondaryPressed: () => context.go(RouteNames.communityAskQuestion),
    );
  }
}

class CommunityNetworkErrorScreen extends StatelessWidget {
  const CommunityNetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkResultScreen(
      title: 'Network error',
      message: "Couldn't post your question right now.",
      icon: Icons.wifi_tethering_error_rounded,
      color: AppColors.warning600,
      buttonIcon: Icons.refresh_rounded,
      buttonLabel: 'Try again',
      // Pops back to whichever form sent the user here, so a retry keeps the
      // text they already typed instead of dropping them on a blank form.
      onPressed: () => context.canPop()
          ? context.pop()
          : context.go(RouteNames.communityAskQuestion),
      secondaryLabel: 'Back to community',
      onSecondaryPressed: () => context.go(RouteNames.community),
    );
  }
}
