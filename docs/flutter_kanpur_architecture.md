# Flutter Kanpur Architecture And Supabase Schema

This document is the shared setup reference for the Flutter Kanpur user app,
admin app, and future web modules.

Flutter Kanpur is the main ecosystem super app. Blog, events, contests,
hackathons, projects, notifications, payments, and admin workflows are feature
modules inside the ecosystem. The blog product can remain modular, but it must
share auth, profiles, notifications, analytics, roles, and audit logging.

## Required Versions

- Flutter: `3.41.0`
- Dart: `3.11.0`
- Backend: Supabase + PostgreSQL
- Env file: `.env`

## Local Setup

Create `.env` in the project root:

```env
SUPABASE_URL=''
SUPABASE_ANON_KEY=''
README_SUPABASE_URL=''
README_SUPABASE_ANON_KEY=''
README_SYNC_SESSION_URL=''
```

Run:

```powershell
flutter clean
flutter pub get
flutter run
```

The first screen checks Supabase initialization and attempts to read
`site_config`. If that table check fails, the app is initialized but the
database schema still needs to be applied.

## Project Structure

```text
lib/
  app/
    environments/
    router/
    theme/
    localization/
  core/
    auth/
    database/
      models/
      services/
      presentation/
    notifications/
    analytics/
    storage/
    payments/
  modules/
    auth/
    profile/
    home/
    events/
    contests/
    hackathons/
    contributions/
    blogs/
    qna/
    leaderboard/
    resources/
    admin/
```

Feature modules should own their screens, providers/controllers, repositories,
and feature-specific models. Shared services such as Supabase, auth, storage,
payments, analytics, and notifications stay in `core/`.

## Feature Ownership

| Feature | Main Tables |
| --- | --- |
| Auth/Profile | `users`, `user_skills`, `user_devices` |
| Admin | `admins`, `admin_permissions`, `audit_logs` |
| Events/Tickets | `events`, `event_registrations`, `tickets`, `payments` |
| Projects | `projects`, `project_members`, `project_tech_stack` |
| Blogs | `blogs`, `tags`, `tag_mappings` |
| QnA | `questions`, `answers`, `tags`, `tag_mappings` |
| Contests/POTD | `contests`, `contest_problems`, `contest_submissions` |
| Hackathons | `hackathons`, `hackathon_teams`, `hackathon_members`, `hackathon_submissions` |
| Leaderboard | `leaderboard_snapshots`, `leaderboard_entries` |
| Notifications | `notifications`, `user_devices` |
| Config | `site_config` |

## Supabase Integration Flow

1. `main.dart` loads `.env`.
2. `Supabase.initialize()` uses `Env.supabaseUrl` and `Env.supabaseAnonKey`.
3. `SupabaseDatabaseService.checkConnection()` queries `site_config`.
4. Feature repositories should use `Supabase.instance.client`.
5. Every write must respect backend constraints and RLS policies.

## Data Modeling Rules

- `users.uid` maps to `auth.users.id`.
- Admins are users with an additional `admins` row.
- Use `is_deleted` for soft deletion on public content.
- Use `status` fields for moderation and workflow state.
- Use `tags` + `tag_mappings` instead of separate tag tables per feature.
- Payment success must be verified server-side before tickets become valid.
- Never trust frontend-only permission checks.
- Keep RLS enabled for all public tables.

## Source Files

- SQL schema: `supabase/schema.sql`
- Supabase setup guide: `docs/supabase_setup.md`
- Supabase env: `.env`
- Health check service: `lib/core/database/services/supabase_database_service.dart`
- Table registry: `lib/core/database/models/app_table_schema.dart`
- Table constants: `lib/core/database/database_tables.dart`
- Base repository: `lib/core/database/repositories/supabase_repository.dart`
