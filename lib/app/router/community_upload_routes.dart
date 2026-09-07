import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_result_screens.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/upload_project_form_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/upload_project_landing_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:go_router/go_router.dart';

/// Root-navigator overlays sit outside [ShellWithBottomNav], so they need their
/// own [Scaffold]/[Material] — otherwise debug builds paint red/yellow text.
class _CommunityUploadShell extends StatelessWidget {
  const _CommunityUploadShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}

/// Upload-project flow on the root navigator so opening it from Explore (or
/// any tab) does not switch the shell to the Community branch first.
List<RouteBase> communityUploadRoutes({
  required GlobalKey<NavigatorState> rootNavigatorKey,
}) {
  return [
    GoRoute(
      path: RouteNames.communityUploadProject,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const _CommunityUploadShell(
        child: UploadProjectLandingScreen(),
      ),
      routes: [
        GoRoute(
          path: RouteNames.communityUploadProjectFormSegment,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const _CommunityUploadShell(
            child: UploadProjectFormScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.communityProjectSubmitted,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const _CommunityUploadShell(
        child: ProjectSubmittedScreen(),
      ),
    ),
  ];
}

/// Opens the upload-project landing screen without changing the active tab.
void openCommunityUploadProject(BuildContext context) {
  context.push(RouteNames.communityUploadProject);
}
