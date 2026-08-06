/// Fixed option lists and form limits for the community forms.
///
/// Tech stack and category were free-text before, which meant the same
/// technology arrived spelled three different ways and could never be
/// filtered on.
class CommunityConstants {
  const CommunityConstants._();

  /// Options offered by the Upload-project "Tech stack" dropdown.
  static const techStackOptions = <String>[
    'Flutter',
    'Dart',
    'React',
    'React Native',
    'Next.js',
    'Node.js',
    'Firebase',
    'Supabase',
    'Python',
    'Django',
    'Java',
    'Kotlin',
    'Swift',
    'TypeScript',
    'MongoDB',
    'PostgreSQL',
    'GraphQL',
    'AWS',
    'Docker',
    'Figma',
  ];

  /// Options offered by the Ask-a-question "Choose a category" dropdown.
  static const questionCategories = <String>[
    'Community Help',
    'Flutter',
    'Dart',
    'State Management',
    'Widgets & UI',
    'Backend & APIs',
    'Testing',
    'Tooling & CI',
    'Career',
    'General',
  ];

  /// Suggested tags; the Tags field also accepts free text.
  static const suggestedTags = <String>[
    'flutter',
    'dart',
    'bloc',
    'riverpod',
    'provider',
    'animation',
    'navigation',
    'performance',
    'testing',
    'firebase',
    'supabase',
    'ui',
  ];

  // ── Form limits ───────────────────────────────────────────────────────────

  static const projectNameMaxLength = 80;

  /// Figma: "Max 120 characters" under Short description.
  static const projectDescriptionMaxLength = 120;
  static const maxTechStack = 6;

  static const questionTitleMaxLength = 150;
  static const questionDetailsMaxLength = 2000;
  static const maxTags = 5;
  static const tagMaxLength = 20;

  static const answerMaxLength = 2000;

  /// Minimums that make a post useful rather than noise.
  static const questionTitleMinLength = 10;
  static const answerMinLength = 2;
}
