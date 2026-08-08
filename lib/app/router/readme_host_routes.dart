import 'package:Readme/features/blog_detail/presentation/pages/blog_detail_loader.dart';
import 'package:Readme/features/communities/domain/entities/community.dart';
import 'package:Readme/features/communities/presentation/pages/community_dashboard_screen.dart';
import 'package:Readme/features/communities/presentation/pages/community_detail_screen.dart';
import 'package:Readme/features/create_blog_page/presentation/pages/create_blog_screen.dart';
import 'package:Readme/features/home_page/domain/entities/blog.dart';
import 'package:Readme/features/legal/presentation/pages/privacy_policy_screen.dart';
import 'package:Readme/features/profile_page/presentation/screens/author_profile_screen.dart';
import 'package:Readme/features/profile_page/presentation/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:go_router/go_router.dart';

/// ReadMe package navigates with absolute paths (`/blog/:id`, `/create`, …).
/// Register those on the host GoRouter so embedded blogs can open overlays.
List<RouteBase> readmeHostRoutes({
  required GlobalKey<NavigatorState> rootNavigatorKey,
}) {
  return [
    GoRoute(
      path: '/blog/:id',
      name: 'readme_blog_detail',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final blog = state.extra;
        if (blog is! Blog) {
          return const _ReadmeMissingExtraScreen(
            message: 'Blog could not be opened.',
          );
        }
        return BlogDetailLoader(blog: blog);
      },
    ),
    GoRoute(
      path: '/create',
      name: 'readme_create',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const CreateBlogScreen(),
    ),
    GoRoute(
      path: '/edit_profile',
      name: 'readme_edit_profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      name: 'readme_privacy_policy',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    // Keep off host `/profile/...` paths — use a dedicated prefix.
    GoRoute(
      path: '/readme-author/:userId',
      name: 'readme_author_profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        if (userId.isEmpty) {
          return const _ReadmeMissingExtraScreen(
            message: 'Author profile could not be opened.',
          );
        }
        return AuthorProfileScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/readme-community/:slug',
      name: 'readme_community_detail',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        final community =
            state.extra is Community ? state.extra as Community : null;
        return CommunityDetailScreen(slug: slug, community: community);
      },
    ),
    GoRoute(
      path: '/readme-community/:slug/dashboard',
      name: 'readme_community_dashboard',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        final community =
            state.extra is Community ? state.extra as Community : null;
        return CommunityDashboardScreen(slug: slug, community: community);
      },
    ),
  ];
}

/// Maps ReadMe absolute paths that collide with host routes onto safe aliases.
///
/// Preserve `extra` by returning null when no remap is needed — callers push
/// with `extra` and go_router keeps it across redirects in recent versions.
String? readmePathRedirect(GoRouterState state) {
  final path = state.uri.path;

  // Author profile: `/profile/<uuid>` (not host profile segments).
  final authorMatch = RegExp(r'^/profile/([^/]+)$').firstMatch(path);
  if (authorMatch != null) {
    final segment = authorMatch.group(1)!;
    const hostProfileSegments = {
      'manage-profile',
      'edit-profile',
      'my-events',
      'my-contests',
      'problem-of-day',
      'about-flutter-kanpur',
      'privacy-policy',
      'terms-of-use',
      'help-center',
      'contact-community-team',
      'report-an-issue',
    };
    if (!hostProfileSegments.contains(segment)) {
      return '/readme-author/$segment';
    }
  }

  // ReadMe community detail vs host `/community/...` segments.
  const hostCommunitySegments = {
    'discussions',
    'discussion',
    'ask-question',
    'members',
    'projects',
    'guidelines',
    'upload-project',
    'project-submitted',
    'network-error',
  };
  final communityMatch =
      RegExp(r'^/community/([^/]+)(/dashboard)?$').firstMatch(path);
  if (communityMatch != null) {
    final slug = communityMatch.group(1)!;
    if (!hostCommunitySegments.contains(slug)) {
      return communityMatch.group(2) != null
          ? '/readme-community/$slug/dashboard'
          : '/readme-community/$slug';
    }
  }

  return null;
}

class _ReadmeMissingExtraScreen extends StatelessWidget {
  const _ReadmeMissingExtraScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RouteNames.blogs);
                    }
                  },
                  child: const Text('Go back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
