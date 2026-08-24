class RouteNames {
  RouteNames._();

  /// Auth
  static const splash = '/';
  static const authLanding = '/auth-landing';
  static const authOptions = '/auth-options';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const emailVerification = '/email-verification';
  static const feedback = '/feedback';

  /// Bottom Navigation
  static const home = '/home';
  static const community = '/community';
  static const events = '/events';
  static const explore = '/explore';
  static const blogs = '/blogs';
  static const profile = '/profile';

  /// Onboarding
  static const onboardingNavigation = '/onboarding';
  static const onboardingSuccess = '/onboarding-success';

  /// Community
  static const communityDiscussions = '/community/discussions';
  static const communityDiscussionDetail = '/community/discussion';
  static const communityAskQuestion = '/community/ask-question';
  static const communityMembers = '/community/members';
  static const communityProjects = '/community/projects';
  static const communityGuidelines = '/community/guidelines';
  static const communityUploadProject = '/community/upload-project';
  static const communityUploadProjectForm = '/community/upload-project/form';
  static const communityProjectSubmitted = '/community/project-submitted';
  static const communityNetworkError = '/community/network-error';

  // IMPORTANT - do not flatten the two routes below into `/community/<name>`.
  //
  // readmePathRedirect() treats any two-segment `/community/<slug>` path that
  // is not in its allowlist as a ReadMe community slug and redirects it to
  // /readme-community/<slug>. That renders ReadMe's "community not found"
  // screen, whose back button pops an empty stack and crashes the app.
  // Its regex only matches two-segment paths, so nesting one level deeper
  // (or living outside /community) keeps these clear of it.

  /// Nested under ask-question: three segments, so the redirect skips it.
  static const communityQuestionPosted = '/community/ask-question/posted';

  /// Top-level: the redirect only inspects `/community/...` and `/profile/...`.
  /// Registered inside the Community shell branch, so the Community tab stays
  /// selected while it is open.
  static const notifications = '/notifications';

  /// Community Segments
  static const communityDiscussionsSegment = 'discussions';
  static const communityDiscussionDetailSegment = 'discussion';
  static const communityAskQuestionSegment = 'ask-question';
  static const communityMembersSegment = 'members';
  static const communityProjectsSegment = 'projects';
  static const communityGuidelinesSegment = 'guidelines';
  static const communityUploadProjectSegment = 'upload-project';
  static const communityUploadProjectFormSegment = 'form';
  static const communityProjectSubmittedSegment = 'project-submitted';
  static const communityNetworkErrorSegment = 'network-error';

  /// Child of [communityAskQuestionSegment] - see [communityQuestionPosted].
  static const communityQuestionPostedSegment = 'posted';

  static const manageProfile = '/profile/manage-profile';
  static const editProfile = '/profile/edit-profile';
  static const myEvents = '/profile/my-events';
  static const myContests = '/profile/my-contests';
  static const problemOfDay = '/profile/problem-of-day';

  /// Browse-all contests, reached by pushing from the Explore dashboard's
  /// "Contests" participation tile.
  static const contests = '/contests';

  /// Browse-all core team, reached from the Explore dashboard's core-team
  /// preview "View all" action.
  static const coreTeam = '/core-team';

  /// Legal
  static const aboutFlutterKanpur = '/profile/about-flutter-kanpur';
  static const privacyPolicy = '/profile/privacy-policy';
  static const termsOfUse = '/profile/terms-of-use';

  /// Support
  static const helpCenter = '/profile/help-center';
  static const contactCommunityTeam = '/profile/contact-community-team';
  static const reportAnIssue = '/profile/report-an-issue';

  /// Onboarding Segments
  static const onboardingProfileSegment = 'profile';
  static const onboardingRoleSegment = 'role';
  static const onboardingSkillsSegment = 'skills';
  static const onboardingLinksSegment = 'links';

  /// Contributor
  static const joinContributor = '/contributor/join';
  static const contributorApplication = '/contributor/application';
  static const reviewApplication = '/contributor/review';
  static const applicationSummary = '/contributor/summary';
  static const applicationSubmitted = '/contributor/submitted';

  static const myContributions = '/contributor/my-contributions';
  static const noContributions = '/contributor/no-contributions';
  static const alreadyContributor = '/contributor/already-contributor';
  static const applicationAlreadySubmitted =
      '/contributor/application-already-submitted';
  static const applicationUnderReview = '/contributor/application-under-review';
  static const applicationRejected = '/contributor/application-rejected';

  /// Contributor Segments
  static const contributorApplicationSegment = 'application';
  static const reviewApplicationSegment = 'review';
  static const applicationSummarySegment = 'summary';
  static const applicationSubmittedSegment = 'submitted';

  static const noContributionsSegment = 'no-contributions';
  static const alreadyContributorSegment = 'already-contributor';
  static const applicationAlreadySubmittedSegment = 'application-submitted';
  static const applicationUnderReviewSegment = 'application-under-review';
  static const applicationRejectedSegment = 'application-rejected';
}
