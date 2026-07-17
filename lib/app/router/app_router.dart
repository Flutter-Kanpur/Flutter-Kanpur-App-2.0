import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/shell_with_bottom_nav.dart';

import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/auth_landing_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/auth_options_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/email_verification_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/blogs/presentation/screens/blogs_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/ask_question_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_discussions_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_guidelines_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_members_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_projects_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_result_screens.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/community_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/discussion_detail_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/upload_project_form_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/screens/upload_project_landing_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/events/presentation/screens/events_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/screens/home_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/screens/onboarding_navigation_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/screens/onboarding_success_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/my_profile_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/edit_profile_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/manage_profile_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/my_contest_detail_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/my_contests_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/my_events_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/problem_of_day_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/screens/app_feedback_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/already_contributor_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/application_submitted_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/application_summary_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/contributor_application_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/contributor_application_submitted_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/contributor_application_under_review_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/contributor_rejected_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/join_as_contributor_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/my_contributions_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/no_contributions_screen.dart';
import 'package:flutter_knp_mobile_app_v2/modules/contributor/presentation/screens/review_application_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellWithBottomNav(
          navigationShell: navigationShell,
          state: state,
        );
      },
      branches: [
        /// Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        /// Community
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.community,
              builder: (context, state) => const CommunityScreen(),

              routes: [
                GoRoute(
                  path: RouteNames.communityDiscussionsSegment,
                  builder: (context, state) =>
                      const CommunityDiscussionsScreen(),
                  routes: [
                    GoRoute(
                      path: ':questionId',
                      builder: (context, state) => DiscussionDetailScreen(
                        questionId: state.pathParameters['questionId'] ?? '',
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path:
                      '${RouteNames.communityDiscussionDetailSegment}/:questionId',
                  builder: (context, state) => DiscussionDetailScreen(
                    questionId: state.pathParameters['questionId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: RouteNames.communityAskQuestionSegment,
                  builder: (context, state) => const AskQuestionScreen(),
                ),
                GoRoute(
                  path: RouteNames.communityMembersSegment,
                  builder: (context, state) => const CommunityMembersScreen(),
                ),
                GoRoute(
                  path: RouteNames.communityProjectsSegment,
                  builder: (context, state) => const CommunityProjectsScreen(),
                ),
                GoRoute(
                  path: RouteNames.communityGuidelinesSegment,
                  builder: (context, state) =>
                      const CommunityGuidelinesScreen(),
                ),
                GoRoute(
                  path: RouteNames.communityUploadProjectSegment,
                  builder: (context, state) =>
                      const UploadProjectLandingScreen(),
                  routes: [
                    GoRoute(
                      path: RouteNames.communityUploadProjectFormSegment,
                      builder: (context, state) =>
                          const UploadProjectFormScreen(),
                    ),
                  ],
                ),
                GoRoute(
                  path: RouteNames.communityProjectSubmittedSegment,
                  builder: (context, state) => const ProjectSubmittedScreen(),
                ),
                GoRoute(
                  path: RouteNames.communityNetworkErrorSegment,
                  builder: (context, state) =>
                      const CommunityNetworkErrorScreen(),
                ),
              ],
            ),
          ],
        ),

        /// Events
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.events,
              builder: (context, state) => const EventsScreen(),
            ),
          ],
        ),

        /// Blogs
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.blogs,
              builder: (context, state) => const BlogsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.profile,
              builder: (context, state) => const MyProfileScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.manageProfile,
              builder: (context, state) => const ManageProfileScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.editProfile,
              builder: (context, state) => const EditProfileScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.myEvents,
              builder: (context, state) => const MyEventsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.myContests,
              builder: (context, state) => const MyContestsScreen(),
              routes: [
                GoRoute(
                  path: ':contestId',
                  builder: (context, state) => MyContestDetailScreen(
                    contestId: state.pathParameters['contestId'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.problemOfDay,
              builder: (context, state) => const ProblemOfDayScreen(),
            ),
          ],
        ),
      ],
    ),

    /// Splash
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    /// Auth Landing
    GoRoute(
      path: RouteNames.authLanding,
      builder: (context, state) => const AuthLandingScreen(),
    ),

    /// Auth Options
    GoRoute(
      path: RouteNames.authOptions,
      builder: (context, state) => const AuthOptionsScreen(),
    ),

    /// Sign In
    GoRoute(
      path: RouteNames.signIn,
      builder: (context, state) => const SignInScreen(),
    ),

    /// Sign Up
    GoRoute(
      path: RouteNames.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),

    /// Onboarding
    GoRoute(
      path: RouteNames.onboardingNavigation,
      builder: (context, state) => const OnboardingNavigationScreen(),
    ),

    /// Onboarding Success
    GoRoute(
      path: RouteNames.onboardingSuccess,
      builder: (context, state) => const OnboardingSuccessScreen(),
    ),

    /// Shared Feedback Screen
    GoRoute(
      path: RouteNames.emailVerification,
      builder: (context, state) => const EmailVerificationScreen(),
    ),
    GoRoute(
      path: RouteNames.feedback,

      builder: (context, state) {
        return state.extra as AppFeedbackScreen;
      },
    ),

    /// Join as Contributor
    GoRoute(
      path: RouteNames.joinContributor,
      builder: (context, state) => const JoinAsContributorScreen(),
    ),

    /// Contributor Application
    GoRoute(
      path: RouteNames.contributorApplication,
      builder: (context, state) => const ContributorApplicationScreen(),
    ),

    /// Review Application
    GoRoute(
      path: RouteNames.reviewApplication,
      builder: (context, state) => const ReviewApplicationScreen(),
    ),

    /// Application Summary
    GoRoute(
      path: RouteNames.applicationSummary,
      builder: (context, state) => const ApplicationSummaryScreen(),
    ),

    /// Application Submitted
    GoRoute(
      path: RouteNames.applicationSubmitted,
      builder: (context, state) => const ApplicationSubmittedScreen(),
    ),

    /// My Contributions
    GoRoute(
      path: RouteNames.myContributions,
      builder: (context, state) => const MyContributionsScreen(),
    ),

    /// No Contributions
    GoRoute(
      path: RouteNames.noContributions,
      builder: (context, state) => const NoContributionsScreen(),
    ),

    /// Already Contributor
    GoRoute(
      path: RouteNames.alreadyContributor,
      builder: (context, state) => const AlreadyContributorScreen(),
    ),

    /// Application Already Submitted
    GoRoute(
      path: RouteNames.applicationAlreadySubmitted,
      builder: (context, state) =>
          const ContributorApplicationSubmittedScreen(),
    ),

    /// Application Under Review
    GoRoute(
      path: RouteNames.applicationUnderReview,
      builder: (context, state) =>
          const ContributorApplicationUnderReviewScreen(),
    ),

    /// Application Rejected
    GoRoute(
      path: RouteNames.applicationRejected,
      builder: (context, state) => const ContributorRejectedScreen(),
    ),
  ],
);
