class AuthConstants {
  AuthConstants._();

  static const String usersTable = 'users';

  static const String uidField = 'uid';
  static const String emailField = 'email';
  static const String emailVerifiedField = 'email_verified';
  static const String displayNameField = 'display_name';
  static const String fullNameField = 'full_name';
  static const String usernameField = 'username';
  static const String photoUrlField = 'photo_url';
  static const String phoneNumberField = 'phone_number';
  static const String bioField = 'bio';
  static const String githubUrlField = 'github_url';
  static const String linkedinUrlField = 'linkedin_url';
  static const String websiteUrlField = 'website_url';
  static const String yoeField = 'years_of_experience';
  static const String rolesField = 'roles';
  static const String statusField = 'status';
  static const String createdAtField = 'created_at';
  static const String updatedAtField = 'updated_at';
  static const String lastLoginAtField = 'last_login_at';
  static const String onboardingCompletedField = 'onboarding_completed';

  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;

  static const int splashDurationMs = 2500;
  static const int resendCooldownSeconds = 60;

  static const String oauthRedirectUrl =
      'com.example.flutter_knp_mobile_app_v2://login-callback';
}
