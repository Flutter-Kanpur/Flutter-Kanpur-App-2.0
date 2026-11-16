-- ================================================================
-- 006 - Achievement badges: categories + per-user progress (FKP-137)
--
-- Adds the fields the "Your Badges" screen needs on top of the existing
-- `badges` / `badge_assignments` tables, and a `badge_progress` table for
-- locked-badge progress ("Progress : 2/3 days").
--
-- Earned  = a row in badge_assignments (unchanged, admin assigns it).
-- Locked  = no assignment; progress comes from badge_progress.current_count
--           against badges.target_count.
--
-- Safe to re-run.
-- ================================================================

-- ─── badges: category + progress definition ─────────────────────
ALTER TABLE public.badges
  ADD COLUMN IF NOT EXISTS category       TEXT NOT NULL DEFAULT 'General',
  ADD COLUMN IF NOT EXISTS sort_order     INT  NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS target_count   INT  NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS progress_unit  TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS how_to_earn    TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS earned_message TEXT NOT NULL DEFAULT '';

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'badges_target_count_positive'
  ) THEN
    ALTER TABLE public.badges
      ADD CONSTRAINT badges_target_count_positive CHECK (target_count >= 1);
  END IF;
END $$;

COMMENT ON COLUMN public.badges.category       IS 'Section on the Your Badges screen, e.g. Daily Practice';
COMMENT ON COLUMN public.badges.sort_order     IS 'Order inside the category (and of categories, by their lowest value)';
COMMENT ON COLUMN public.badges.target_count   IS 'Steps needed to earn, e.g. 7 for a 7-day streak';
COMMENT ON COLUMN public.badges.progress_unit  IS 'Unit shown with progress, e.g. days, events';
COMMENT ON COLUMN public.badges.how_to_earn    IS 'Shown on the locked badge detail';
COMMENT ON COLUMN public.badges.earned_message IS 'Footer shown on the earned badge detail';

CREATE INDEX IF NOT EXISTS idx_badges_category_sort
  ON public.badges (category, sort_order);

-- ─── badge_progress: per-user progress toward a badge ───────────
CREATE TABLE IF NOT EXISTS public.badge_progress (
  badge_id      UUID NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
  user_uid      UUID NOT NULL REFERENCES public.users(uid) ON DELETE CASCADE,
  current_count INT  NOT NULL DEFAULT 0 CHECK (current_count >= 0),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (badge_id, user_uid)
);

CREATE INDEX IF NOT EXISTS idx_badge_progress_user
  ON public.badge_progress (user_uid);

ALTER TABLE public.badge_progress ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "badge_progress_read_own"     ON public.badge_progress;
DROP POLICY IF EXISTS "BadgeProgress: admins full"  ON public.badge_progress;

CREATE POLICY "badge_progress_read_own" ON public.badge_progress
  FOR SELECT TO authenticated USING (user_uid = auth.uid());

CREATE POLICY "BadgeProgress: admins full" ON public.badge_progress
  FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ─── Assigning a badge completes its progress ───────────────────
-- Keeps progress consistent with assignments so an earned badge never
-- shows a partial bar, whoever inserts the assignment.
CREATE OR REPLACE FUNCTION public.complete_badge_progress_on_assign()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.badge_progress (badge_id, user_uid, current_count, updated_at)
  SELECT NEW.badge_id, NEW.user_uid, b.target_count, now()
  FROM public.badges b
  WHERE b.id = NEW.badge_id
  ON CONFLICT (badge_id, user_uid)
  DO UPDATE SET current_count = GREATEST(public.badge_progress.current_count, EXCLUDED.current_count),
                updated_at    = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_badge_assignment_completes_progress ON public.badge_assignments;
CREATE TRIGGER trg_badge_assignment_completes_progress
  AFTER INSERT ON public.badge_assignments
  FOR EACH ROW EXECUTE FUNCTION public.complete_badge_progress_on_assign();

-- Reload PostgREST so the new columns/table are visible to the API at once.
NOTIFY pgrst, 'reload schema';
