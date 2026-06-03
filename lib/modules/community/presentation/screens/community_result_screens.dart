import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_result_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:go_router/go_router.dart';

class ProjectSubmittedScreen extends StatelessWidget {
  const ProjectSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkResultScreen(
      title: 'Project submitted',
      message:
          'Thanks for sharing your project. Our team will review it and notify you once it is approved.',
      icon: Icons.check_rounded,
      color: AppColors.primary,
      buttonLabel: 'View my projects',
      onPressed: () => context.go(RouteNames.communityProjects),
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
      color: AppColors.errorColor,
      buttonLabel: 'Try again',
      onPressed: () => context.go(RouteNames.communityAskQuestion),
    );
  }
}
