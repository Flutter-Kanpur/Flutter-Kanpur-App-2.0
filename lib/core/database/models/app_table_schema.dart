class AppTableSchema {
  const AppTableSchema({
    required this.name,
    required this.module,
    required this.purpose,
    required this.fields,
  });

  final String name;
  final String module;
  final String purpose;
  final List<String> fields;
}

const appTableSchemas = <AppTableSchema>[
  AppTableSchema(
    name: 'users',
    module: 'auth/profile',
    purpose: 'Public app profile linked with Supabase Auth user id.',
    fields: ['uid', 'email', 'display_name', 'username', 'status'],
  ),
  AppTableSchema(
    name: 'admins',
    module: 'admin',
    purpose: 'Admin app access, role, active/revoked state.',
    fields: ['uid', 'role', 'active', 'created_by', 'updated_by'],
  ),
  AppTableSchema(
    name: 'events',
    module: 'events',
    purpose: 'Meetups, workshops, hackathons, and ecosystem events.',
    fields: ['id', 'slug', 'title', 'event_type', 'capacity', 'start_at'],
  ),
  AppTableSchema(
    name: 'event_registrations',
    module: 'events/tickets',
    purpose: 'User event registration, ticket, payment, and check-in state.',
    fields: ['id', 'event_id', 'user_uid', 'ticket_id', 'payment_status'],
  ),
  AppTableSchema(
    name: 'projects',
    module: 'contributions',
    purpose: 'Community projects, owners, links, members, and tech stack.',
    fields: ['id', 'slug', 'title', 'owner_uid', 'status'],
  ),
  AppTableSchema(
    name: 'blogs',
    module: 'blogs',
    purpose: 'Integrated blog content shared with Flutter Kanpur ecosystem.',
    fields: ['id', 'slug', 'title', 'author_uid', 'status'],
  ),
  AppTableSchema(
    name: 'questions',
    module: 'community/qna',
    purpose: 'Developer questions, answers, accepted answer flow.',
    fields: ['id', 'title', 'author_uid', 'answer_count', 'status'],
  ),
  AppTableSchema(
    name: 'contests',
    module: 'contests',
    purpose: 'Coding contests, problem-of-the-day, submissions, judging.',
    fields: ['id', 'slug', 'title', 'contest_type', 'start_at', 'end_at'],
  ),
  AppTableSchema(
    name: 'hackathons',
    module: 'hackathons',
    purpose: 'Hackathon events, teams, members, submissions, judging.',
    fields: ['id', 'slug', 'title', 'event_id', 'status'],
  ),
  AppTableSchema(
    name: 'payments',
    module: 'payments',
    purpose: 'Razorpay/payment verification source of truth.',
    fields: ['id', 'provider', 'provider_payment_id', 'amount', 'status'],
  ),
  AppTableSchema(
    name: 'notifications',
    module: 'notifications',
    purpose: 'Cross-module in-app notifications and FCM delivery tracking.',
    fields: ['id', 'user_uid', 'module', 'title', 'read_at'],
  ),
  AppTableSchema(
    name: 'audit_logs',
    module: 'admin/security',
    purpose: 'Admin/user action trail with before/after JSON metadata.',
    fields: ['id', 'actor_uid', 'action', 'entity_type', 'metadata'],
  ),
  AppTableSchema(
    name: 'home_carousel_slides',
    module: 'home',
    purpose: 'Server-driven home/explore carousel slides from admin panel.',
    fields: [
      'id',
      'screen',
      'content_type',
      'image_url',
      'video_url',
      'title',
      'body',
      'btn_text',
      'btn_url',
      'sort_order',
      'is_active',
    ],
  ),
  AppTableSchema(
    name: 'community_memberships',
    module: 'community',
    purpose: 'Active contributors shown on the Community screen carousel.',
    fields: ['user_uid', 'role', 'membership_status', 'community_key', 'joined_at'],
  ),
  AppTableSchema(
    name: 'core_team_members',
    module: 'explore',
    purpose: 'Core / organising team shown on Explore and Core Team screens.',
    fields: [
      'user_uid',
      'role',
      'team_section',
      'is_lead',
      'sort_order',
      'is_active',
    ],
  ),
];
