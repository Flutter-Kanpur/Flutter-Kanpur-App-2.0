-- ================================================================
-- Flutter Kanpur — Complete RLS Policies
-- Run entire script in Supabase SQL Editor
-- Safe to re-run: all DROP IF EXISTS before CREATE
-- ================================================================

-- ─── users ───────────────────────────────────────────────────────
-- uid is uuid, auth.uid() is uuid — no cast needed
DROP POLICY IF EXISTS "users_select_own"      ON public.users;
DROP POLICY IF EXISTS "users_select_public"   ON public.users;
DROP POLICY IF EXISTS "users_insert_own"      ON public.users;
DROP POLICY IF EXISTS "users_update_own"      ON public.users;
DROP POLICY IF EXISTS "users_delete_own"      ON public.users;
DROP POLICY IF EXISTS "users_admin_full"      ON public.users;

-- Any logged-in user can see any member (needed for member listings, profiles)
CREATE POLICY "users_select_public" ON public.users
  FOR SELECT TO authenticated USING (true);

-- Each user can only insert/update their own row
CREATE POLICY "users_insert_own" ON public.users
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = uid);

CREATE POLICY "users_update_own" ON public.users
  FOR UPDATE TO authenticated USING (auth.uid() = uid);

-- Admins get full access
CREATE POLICY "users_admin_full" ON public.users
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── user_skills ─────────────────────────────────────────────────
DROP POLICY IF EXISTS "user_skills_read_all" ON public.user_skills;
DROP POLICY IF EXISTS "user_skills_own"      ON public.user_skills;

CREATE POLICY "user_skills_read_all" ON public.user_skills
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "user_skills_own" ON public.user_skills
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

-- ─── events ──────────────────────────────────────────────────────
DROP POLICY IF EXISTS "events_read_all"  ON public.events;
DROP POLICY IF EXISTS "events_admin_full" ON public.events;
-- (admin policies from migration 002 are dropped and recreated below)
DROP POLICY IF EXISTS "Events: admins full" ON public.events;
DROP POLICY IF EXISTS "Events: read published" ON public.events;

CREATE POLICY "events_read_all" ON public.events
  FOR SELECT TO authenticated USING (is_deleted = false);

CREATE POLICY "events_admin_full" ON public.events
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── event_registrations ─────────────────────────────────────────
DROP POLICY IF EXISTS "event_registrations_own"        ON public.event_registrations;
DROP POLICY IF EXISTS "event_registrations_admin_full" ON public.event_registrations;

CREATE POLICY "event_registrations_own" ON public.event_registrations
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "event_registrations_admin_full" ON public.event_registrations
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── tickets ─────────────────────────────────────────────────────
DROP POLICY IF EXISTS "tickets_own"        ON public.tickets;
DROP POLICY IF EXISTS "tickets_admin_full" ON public.tickets;

CREATE POLICY "tickets_own" ON public.tickets
  FOR SELECT TO authenticated USING (auth.uid() = user_uid);

CREATE POLICY "tickets_admin_full" ON public.tickets
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── payments ────────────────────────────────────────────────────
DROP POLICY IF EXISTS "payments_own"        ON public.payments;
DROP POLICY IF EXISTS "payments_admin_full" ON public.payments;

CREATE POLICY "payments_own" ON public.payments
  FOR SELECT TO authenticated USING (auth.uid() = user_uid);

CREATE POLICY "payments_admin_full" ON public.payments
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── blogs ───────────────────────────────────────────────────────
DROP POLICY IF EXISTS "blogs_read_published"  ON public.blogs;
DROP POLICY IF EXISTS "blogs_author_manage"   ON public.blogs;
DROP POLICY IF EXISTS "blogs_admin_full"      ON public.blogs;
DROP POLICY IF EXISTS "Blogs: read published"  ON public.blogs;
DROP POLICY IF EXISTS "Blogs: author manage own" ON public.blogs;
DROP POLICY IF EXISTS "Blogs: admins full"    ON public.blogs;

CREATE POLICY "blogs_read_published" ON public.blogs
  FOR SELECT TO authenticated
  USING (status = 'published' AND is_deleted = false);

CREATE POLICY "blogs_author_manage" ON public.blogs
  FOR ALL TO authenticated
  USING (auth.uid() = author_uid) WITH CHECK (auth.uid() = author_uid);

CREATE POLICY "blogs_admin_full" ON public.blogs
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── projects ────────────────────────────────────────────────────
DROP POLICY IF EXISTS "projects_read_all"      ON public.projects;
DROP POLICY IF EXISTS "projects_owner_manage"  ON public.projects;
DROP POLICY IF EXISTS "projects_admin_full"    ON public.projects;

CREATE POLICY "projects_read_all" ON public.projects
  FOR SELECT TO authenticated USING (is_deleted = false);

CREATE POLICY "projects_owner_manage" ON public.projects
  FOR ALL TO authenticated
  USING (auth.uid() = owner_uid) WITH CHECK (auth.uid() = owner_uid);

CREATE POLICY "projects_admin_full" ON public.projects
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── project_tech_stack ──────────────────────────────────────────
DROP POLICY IF EXISTS "project_tech_stack_read" ON public.project_tech_stack;
DROP POLICY IF EXISTS "project_tech_stack_admin" ON public.project_tech_stack;

CREATE POLICY "project_tech_stack_read" ON public.project_tech_stack
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "project_tech_stack_admin" ON public.project_tech_stack
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── project_members ─────────────────────────────────────────────
DROP POLICY IF EXISTS "project_members_read"       ON public.project_members;
DROP POLICY IF EXISTS "project_members_write_own"  ON public.project_members;

CREATE POLICY "project_members_read" ON public.project_members
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "project_members_write_own" ON public.project_members
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_uid);

-- ─── questions ───────────────────────────────────────────────────
DROP POLICY IF EXISTS "questions_read_all"      ON public.questions;
DROP POLICY IF EXISTS "questions_author_manage" ON public.questions;

CREATE POLICY "questions_read_all" ON public.questions
  FOR SELECT TO authenticated USING (is_deleted = false);

CREATE POLICY "questions_author_manage" ON public.questions
  FOR ALL TO authenticated
  USING (auth.uid() = author_uid) WITH CHECK (auth.uid() = author_uid);

-- ─── answers ─────────────────────────────────────────────────────
DROP POLICY IF EXISTS "answers_read_all"      ON public.answers;
DROP POLICY IF EXISTS "answers_author_manage" ON public.answers;

CREATE POLICY "answers_read_all" ON public.answers
  FOR SELECT TO authenticated USING (is_deleted = false);

CREATE POLICY "answers_author_manage" ON public.answers
  FOR ALL TO authenticated
  USING (auth.uid() = author_uid) WITH CHECK (auth.uid() = author_uid);

-- ─── tags & tag_mappings ─────────────────────────────────────────
DROP POLICY IF EXISTS "tags_read_all"         ON public.tags;
DROP POLICY IF EXISTS "tag_mappings_read_all" ON public.tag_mappings;

CREATE POLICY "tags_read_all" ON public.tags
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "tag_mappings_read_all" ON public.tag_mappings
  FOR SELECT TO authenticated USING (true);

-- ─── featured_resources ──────────────────────────────────────────
DROP POLICY IF EXISTS "featured_resources_read"       ON public.featured_resources;
DROP POLICY IF EXISTS "featured_resources_admin_full" ON public.featured_resources;

CREATE POLICY "featured_resources_read" ON public.featured_resources
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "featured_resources_admin_full" ON public.featured_resources
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── community_memberships ───────────────────────────────────────
DROP POLICY IF EXISTS "community_memberships_own"        ON public.community_memberships;
DROP POLICY IF EXISTS "community_memberships_admin_full" ON public.community_memberships;

CREATE POLICY "community_memberships_own" ON public.community_memberships
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "community_memberships_admin_full" ON public.community_memberships
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── contests ────────────────────────────────────────────────────
DROP POLICY IF EXISTS "contests_read_all"  ON public.contests;
DROP POLICY IF EXISTS "contests_admin_full" ON public.contests;

CREATE POLICY "contests_read_all" ON public.contests
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "contests_admin_full" ON public.contests
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── contest_problems ────────────────────────────────────────────
DROP POLICY IF EXISTS "contest_problems_read"       ON public.contest_problems;
DROP POLICY IF EXISTS "contest_problems_admin_full" ON public.contest_problems;

CREATE POLICY "contest_problems_read" ON public.contest_problems
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "contest_problems_admin_full" ON public.contest_problems
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── contest_submissions ─────────────────────────────────────────
DROP POLICY IF EXISTS "contest_submissions_own"        ON public.contest_submissions;
DROP POLICY IF EXISTS "contest_submissions_admin_full" ON public.contest_submissions;

CREATE POLICY "contest_submissions_own" ON public.contest_submissions
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "contest_submissions_admin_full" ON public.contest_submissions
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── hackathons ──────────────────────────────────────────────────
DROP POLICY IF EXISTS "hackathons_read_all"   ON public.hackathons;
DROP POLICY IF EXISTS "hackathons_admin_full" ON public.hackathons;

CREATE POLICY "hackathons_read_all" ON public.hackathons
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "hackathons_admin_full" ON public.hackathons
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── hackathon_teams ─────────────────────────────────────────────
DROP POLICY IF EXISTS "hackathon_teams_read"           ON public.hackathon_teams;
DROP POLICY IF EXISTS "hackathon_teams_leader_manage"  ON public.hackathon_teams;

CREATE POLICY "hackathon_teams_read" ON public.hackathon_teams
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "hackathon_teams_leader_manage" ON public.hackathon_teams
  FOR ALL TO authenticated
  USING (auth.uid() = leader_uid) WITH CHECK (auth.uid() = leader_uid);

-- ─── hackathon_members ───────────────────────────────────────────
DROP POLICY IF EXISTS "hackathon_members_read"       ON public.hackathon_members;
DROP POLICY IF EXISTS "hackathon_members_write_own"  ON public.hackathon_members;

CREATE POLICY "hackathon_members_read" ON public.hackathon_members
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "hackathon_members_write_own" ON public.hackathon_members
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_uid);

-- ─── hackathon_submissions ───────────────────────────────────────
DROP POLICY IF EXISTS "hackathon_submissions_read"        ON public.hackathon_submissions;
DROP POLICY IF EXISTS "hackathon_submissions_admin_full"  ON public.hackathon_submissions;

CREATE POLICY "hackathon_submissions_read" ON public.hackathon_submissions
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "hackathon_submissions_admin_full" ON public.hackathon_submissions
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── leaderboard ─────────────────────────────────────────────────
DROP POLICY IF EXISTS "leaderboard_snapshots_read"  ON public.leaderboard_snapshots;
DROP POLICY IF EXISTS "leaderboard_entries_read"    ON public.leaderboard_entries;
DROP POLICY IF EXISTS "leaderboard_snapshots_admin" ON public.leaderboard_snapshots;
DROP POLICY IF EXISTS "leaderboard_entries_admin"   ON public.leaderboard_entries;

CREATE POLICY "leaderboard_snapshots_read" ON public.leaderboard_snapshots
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "leaderboard_entries_read" ON public.leaderboard_entries
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "leaderboard_snapshots_admin" ON public.leaderboard_snapshots
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "leaderboard_entries_admin" ON public.leaderboard_entries
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── role_suggestions ────────────────────────────────────────────
DROP POLICY IF EXISTS "role_suggestions_own"        ON public.role_suggestions;
DROP POLICY IF EXISTS "role_suggestions_admin_full" ON public.role_suggestions;

CREATE POLICY "role_suggestions_own" ON public.role_suggestions
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "role_suggestions_admin_full" ON public.role_suggestions
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── user_devices ────────────────────────────────────────────────
DROP POLICY IF EXISTS "user_devices_own" ON public.user_devices;

CREATE POLICY "user_devices_own" ON public.user_devices
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

-- ─── notifications ───────────────────────────────────────────────
DROP POLICY IF EXISTS "notifications_own"        ON public.notifications;
DROP POLICY IF EXISTS "notifications_admin_full" ON public.notifications;

CREATE POLICY "notifications_own" ON public.notifications
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "notifications_admin_full" ON public.notifications
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── site_config ─────────────────────────────────────────────────
DROP POLICY IF EXISTS "site_config_read_all"   ON public.site_config;
DROP POLICY IF EXISTS "site_config_admin_full" ON public.site_config;

CREATE POLICY "site_config_read_all" ON public.site_config
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "site_config_admin_full" ON public.site_config
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── audit_logs ──────────────────────────────────────────────────
DROP POLICY IF EXISTS "audit_logs_admin_only" ON public.audit_logs;

CREATE POLICY "audit_logs_admin_only" ON public.audit_logs
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── contributor_applications ────────────────────────────────────
DROP POLICY IF EXISTS "contrib_apps_own"         ON public.contributor_applications;
DROP POLICY IF EXISTS "contrib_apps_anon_insert" ON public.contributor_applications;
DROP POLICY IF EXISTS "contrib_apps_admin_full"  ON public.contributor_applications;

-- Unauthenticated users can submit the form (before they have an account)
CREATE POLICY "contrib_apps_anon_insert" ON public.contributor_applications
  FOR INSERT WITH CHECK (true);

-- Logged-in users see and manage their own application
CREATE POLICY "contrib_apps_own" ON public.contributor_applications
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "contrib_apps_admin_full" ON public.contributor_applications
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── open_calls ──────────────────────────────────────────────────
DROP POLICY IF EXISTS "open_calls_read_active" ON public.open_calls;
DROP POLICY IF EXISTS "OpenCalls: admins full" ON public.open_calls;

CREATE POLICY "open_calls_read_active" ON public.open_calls
  FOR SELECT TO authenticated USING (status = 'active');

CREATE POLICY "OpenCalls: admins full" ON public.open_calls
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── open_call_applicants ────────────────────────────────────────
-- Column is user_uid (NOT applicant_uid — that column doesn't exist)
DROP POLICY IF EXISTS "open_call_applicants_own"        ON public.open_call_applicants;
DROP POLICY IF EXISTS "open_call_applicants_anon"       ON public.open_call_applicants;
DROP POLICY IF EXISTS "OpenCallApp: admins full"        ON public.open_call_applicants;

CREATE POLICY "open_call_applicants_anon" ON public.open_call_applicants
  FOR INSERT WITH CHECK (true);

CREATE POLICY "open_call_applicants_own" ON public.open_call_applicants
  FOR ALL TO authenticated
  USING (auth.uid() = user_uid) WITH CHECK (auth.uid() = user_uid);

CREATE POLICY "OpenCallApp: admins full" ON public.open_call_applicants
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── badges ──────────────────────────────────────────────────────
DROP POLICY IF EXISTS "badges_read_all"   ON public.badges;
DROP POLICY IF EXISTS "Badges: admins full" ON public.badges;

CREATE POLICY "badges_read_all" ON public.badges
  FOR SELECT TO authenticated USING (active = true);

CREATE POLICY "Badges: admins full" ON public.badges
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── badge_assignments ───────────────────────────────────────────
DROP POLICY IF EXISTS "badge_assignments_read_all" ON public.badge_assignments;
DROP POLICY IF EXISTS "BadgeAssign: admins full"   ON public.badge_assignments;

CREATE POLICY "badge_assignments_read_all" ON public.badge_assignments
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "BadgeAssign: admins full" ON public.badge_assignments
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── announcements ───────────────────────────────────────────────
DROP POLICY IF EXISTS "announcements_read_active" ON public.announcements;
DROP POLICY IF EXISTS "announcements_admin_full"  ON public.announcements;

CREATE POLICY "announcements_read_active" ON public.announcements
  FOR SELECT TO authenticated USING (is_active = true);

CREATE POLICY "announcements_admin_full" ON public.announcements
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── admins table ────────────────────────────────────────────────
DROP POLICY IF EXISTS "admins_read_self"  ON public.admins;
DROP POLICY IF EXISTS "admins_admin_full" ON public.admins;

CREATE POLICY "admins_read_self" ON public.admins
  FOR SELECT TO authenticated USING (auth.uid() = uid);

CREATE POLICY "admins_admin_full" ON public.admins
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── admin_permissions ───────────────────────────────────────────
DROP POLICY IF EXISTS "admin_permissions_read_own"   ON public.admin_permissions;
DROP POLICY IF EXISTS "admin_permissions_admin_full" ON public.admin_permissions;

CREATE POLICY "admin_permissions_read_own" ON public.admin_permissions
  FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM public.admins WHERE uid = auth.uid() AND admin_uid = auth.uid())
  );

CREATE POLICY "admin_permissions_admin_full" ON public.admin_permissions
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ================================================================
-- Storage: media bucket (events images, covers, etc.)
-- ================================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('media', 'media', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "media_public_read"   ON storage.objects;
DROP POLICY IF EXISTS "media_admin_write"   ON storage.objects;
DROP POLICY IF EXISTS "media_admin_update"  ON storage.objects;
DROP POLICY IF EXISTS "media_admin_delete"  ON storage.objects;

-- Anyone can view images (bucket is public anyway, but policy makes it explicit)
CREATE POLICY "media_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'media');

CREATE POLICY "media_admin_write" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'media' AND public.is_admin());

CREATE POLICY "media_admin_update" ON storage.objects
  FOR UPDATE TO authenticated
  USING (bucket_id = 'media' AND public.is_admin());

CREATE POLICY "media_admin_delete" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'media' AND public.is_admin());

-- ================================================================
-- END — All policies applied
-- ================================================================
