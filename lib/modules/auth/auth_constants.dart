class AuthConstants {
  AuthConstants._();

  // Supabase table
  static const String usersTable = 'users';

  // Column names
  static const String uidField = 'uid';
  static const String emailField = 'email';
  static const String usernameField = 'username';
  static const String displayNameField = 'display_name';
  static const String photoUrlField = 'photo_url';
  static const String isContributorField = 'is_contributor';
  static const String contributorStatusField = 'contributor_status';
  static const String rolesField = 'roles';
  static const String communityRolesField = 'community_roles';
  static const String skillsField = 'skills';
  static const String yoeField = 'yoe';
  static const String introField = 'intro';
  static const String githubField = 'github';
  static const String linkedinField = 'linkedin';
  static const String websiteField = 'website';
  static const String taglineField = 'tagline';
  static const String emailVerifiedField = 'email_verified';
  static const String createdAtField = 'created_at';
  static const String lastLoginAtField = 'last_login_at';

  // Validation
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;

  // Timing
  static const int splashDurationMs = 2500;
  static const int resendCooldownSeconds = 60;

  // Google sign-in web client ID (set in firebase/google-services.json)
  static const String googleWebClientId = '';
}
