-- Community Engagement Migration
--
-- Adds the pieces the community feed UI needs but 002 did not provide:
--   * question_saves (bookmark) table + RLS
--   * comment_count on answers
--   * triggers that keep questions.like_count / answers.like_count /
--     questions.answer_count / answers.comment_count in sync
--
-- 002 left the client calling increment_answer_likes / decrement_answer_likes
-- RPCs that were never created, so every "like" round-tripped into a
-- PostgrestException. Counters are handled by triggers here instead: they are
-- atomic, cannot drift, and save the client an extra round trip.

-- ============================================================================
-- 1. CREATE question_saves TABLE - Bookmarks
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.question_saves (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL,
  user_uid UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),

  CONSTRAINT question_saves_pkey PRIMARY KEY (id),
  CONSTRAINT question_saves_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE,
  CONSTRAINT question_saves_user_uid_fkey FOREIGN KEY (user_uid) REFERENCES public.users(uid) ON DELETE CASCADE,
  CONSTRAINT question_saves_unique UNIQUE(question_id, user_uid)
);

CREATE INDEX IF NOT EXISTS idx_question_saves_question ON public.question_saves(question_id);
CREATE INDEX IF NOT EXISTS idx_question_saves_user ON public.question_saves(user_uid);

ALTER TABLE public.questions
ADD COLUMN IF NOT EXISTS save_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE public.answers
ADD COLUMN IF NOT EXISTS comment_count INTEGER NOT NULL DEFAULT 0;

-- Upload-project form collects a screenshot; projects had nowhere to put it.
ALTER TABLE public.projects
ADD COLUMN IF NOT EXISTS cover_image_url TEXT;

-- ============================================================================
-- 1b. Repair missing unique constraints on the like tables
-- ============================================================================
--
-- 002 declared question_likes_unique / answer_likes_unique inside its
-- CREATE TABLE IF NOT EXISTS. Live inspection shows both tables carrying only
-- their PK and FKs, so the CREATE was skipped against pre-existing tables and
-- the constraints never landed. Without them a double tap inserts two rows and
-- the counter triggers below would over-count.
--
-- De-duplicate first, otherwise ADD CONSTRAINT fails on existing dupes.

DELETE FROM public.question_likes a
 USING public.question_likes b
 WHERE a.ctid < b.ctid
   AND a.question_id = b.question_id
   AND a.user_uid = b.user_uid;

DELETE FROM public.answer_likes a
 USING public.answer_likes b
 WHERE a.ctid < b.ctid
   AND a.answer_id = b.answer_id
   AND a.user_uid = b.user_uid;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'question_likes_unique'
  ) THEN
    ALTER TABLE public.question_likes
      ADD CONSTRAINT question_likes_unique UNIQUE (question_id, user_uid);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'answer_likes_unique'
  ) THEN
    ALTER TABLE public.answer_likes
      ADD CONSTRAINT answer_likes_unique UNIQUE (answer_id, user_uid);
  END IF;
END $$;

-- ============================================================================
-- 2. RLS for question_saves
-- ============================================================================

ALTER TABLE public.question_saves ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "question_saves_select_policy" ON public.question_saves;
CREATE POLICY "question_saves_select_policy" ON public.question_saves
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "question_saves_insert_policy" ON public.question_saves;
CREATE POLICY "question_saves_insert_policy" ON public.question_saves
  FOR INSERT WITH CHECK (auth.uid() = user_uid);

DROP POLICY IF EXISTS "question_saves_delete_policy" ON public.question_saves;
CREATE POLICY "question_saves_delete_policy" ON public.question_saves
  FOR DELETE USING (auth.uid() = user_uid);

-- ============================================================================
-- 3. Counter triggers
-- ============================================================================

-- questions.like_count ← question_likes
CREATE OR REPLACE FUNCTION public.sync_question_like_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE public.questions
       SET like_count = COALESCE(like_count, 0) + 1
     WHERE id = NEW.question_id;
    RETURN NEW;
  ELSE
    UPDATE public.questions
       SET like_count = GREATEST(COALESCE(like_count, 0) - 1, 0)
     WHERE id = OLD.question_id;
    RETURN OLD;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_question_likes_count ON public.question_likes;
CREATE TRIGGER trg_question_likes_count
AFTER INSERT OR DELETE ON public.question_likes
FOR EACH ROW EXECUTE FUNCTION public.sync_question_like_count();

-- questions.save_count ← question_saves
CREATE OR REPLACE FUNCTION public.sync_question_save_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE public.questions
       SET save_count = COALESCE(save_count, 0) + 1
     WHERE id = NEW.question_id;
    RETURN NEW;
  ELSE
    UPDATE public.questions
       SET save_count = GREATEST(COALESCE(save_count, 0) - 1, 0)
     WHERE id = OLD.question_id;
    RETURN OLD;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_question_saves_count ON public.question_saves;
CREATE TRIGGER trg_question_saves_count
AFTER INSERT OR DELETE ON public.question_saves
FOR EACH ROW EXECUTE FUNCTION public.sync_question_save_count();

-- answers.like_count ← answer_likes
CREATE OR REPLACE FUNCTION public.sync_answer_like_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    UPDATE public.answers
       SET like_count = COALESCE(like_count, 0) + 1
     WHERE id = NEW.answer_id;
    RETURN NEW;
  ELSE
    UPDATE public.answers
       SET like_count = GREATEST(COALESCE(like_count, 0) - 1, 0)
     WHERE id = OLD.answer_id;
    RETURN OLD;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_answer_likes_count ON public.answer_likes;
CREATE TRIGGER trg_answer_likes_count
AFTER INSERT OR DELETE ON public.answer_likes
FOR EACH ROW EXECUTE FUNCTION public.sync_answer_like_count();

-- answers.comment_count ← answer_comments (respects the is_deleted soft delete)
CREATE OR REPLACE FUNCTION public.sync_answer_comment_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    IF NOT NEW.is_deleted THEN
      UPDATE public.answers
         SET comment_count = COALESCE(comment_count, 0) + 1
       WHERE id = NEW.answer_id;
    END IF;
    RETURN NEW;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF OLD.is_deleted IS DISTINCT FROM NEW.is_deleted THEN
      UPDATE public.answers
         SET comment_count = GREATEST(
               COALESCE(comment_count, 0) + (CASE WHEN NEW.is_deleted THEN -1 ELSE 1 END),
               0)
       WHERE id = NEW.answer_id;
    END IF;
    RETURN NEW;
  ELSE
    IF NOT OLD.is_deleted THEN
      UPDATE public.answers
         SET comment_count = GREATEST(COALESCE(comment_count, 0) - 1, 0)
       WHERE id = OLD.answer_id;
    END IF;
    RETURN OLD;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_answer_comments_count ON public.answer_comments;
CREATE TRIGGER trg_answer_comments_count
AFTER INSERT OR UPDATE OR DELETE ON public.answer_comments
FOR EACH ROW EXECUTE FUNCTION public.sync_answer_comment_count();

-- questions.answer_count ← answers (respects the is_deleted soft delete)
CREATE OR REPLACE FUNCTION public.sync_question_answer_count()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    IF NOT COALESCE(NEW.is_deleted, false) THEN
      UPDATE public.questions
         SET answer_count = COALESCE(answer_count, 0) + 1
       WHERE id = NEW.question_id;
    END IF;
    RETURN NEW;
  ELSIF (TG_OP = 'UPDATE') THEN
    IF COALESCE(OLD.is_deleted, false) IS DISTINCT FROM COALESCE(NEW.is_deleted, false) THEN
      UPDATE public.questions
         SET answer_count = GREATEST(
               COALESCE(answer_count, 0) + (CASE WHEN NEW.is_deleted THEN -1 ELSE 1 END),
               0)
       WHERE id = NEW.question_id;
    END IF;
    RETURN NEW;
  ELSE
    IF NOT COALESCE(OLD.is_deleted, false) THEN
      UPDATE public.questions
         SET answer_count = GREATEST(COALESCE(answer_count, 0) - 1, 0)
       WHERE id = OLD.question_id;
    END IF;
    RETURN OLD;
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_answers_question_count ON public.answers;
CREATE TRIGGER trg_answers_question_count
AFTER INSERT OR UPDATE OR DELETE ON public.answers
FOR EACH ROW EXECUTE FUNCTION public.sync_question_answer_count();

-- ============================================================================
-- 4. Backfill counters so existing rows match the new triggers
-- ============================================================================

WITH like_counts AS (
  SELECT question_id, COUNT(*)::int AS c FROM public.question_likes GROUP BY question_id
), save_counts AS (
  SELECT question_id, COUNT(*)::int AS c FROM public.question_saves GROUP BY question_id
), answer_counts AS (
  SELECT question_id, COUNT(*)::int AS c FROM public.answers WHERE NOT COALESCE(is_deleted, false) GROUP BY question_id
)
UPDATE public.questions q
   SET like_count   = COALESCE(lc.c, 0),
       save_count   = COALESCE(sc.c, 0),
       answer_count = COALESCE(ac.c, 0)
  FROM (SELECT id FROM public.questions) ids
  LEFT JOIN like_counts   lc ON lc.question_id = ids.id
  LEFT JOIN save_counts   sc ON sc.question_id = ids.id
  LEFT JOIN answer_counts ac ON ac.question_id = ids.id
 WHERE q.id = ids.id;

WITH answer_like_counts AS (
  SELECT answer_id, COUNT(*)::int AS c FROM public.answer_likes GROUP BY answer_id
), answer_comment_counts AS (
  SELECT answer_id, COUNT(*)::int AS c FROM public.answer_comments WHERE NOT is_deleted GROUP BY answer_id
)
UPDATE public.answers a
   SET like_count    = COALESCE(alc.c, 0),
       comment_count = COALESCE(acc.c, 0)
  FROM (SELECT id FROM public.answers) ids
  LEFT JOIN answer_like_counts    alc ON alc.answer_id = ids.id
  LEFT JOIN answer_comment_counts acc ON acc.answer_id = ids.id
 WHERE a.id = ids.id;

-- ============================================================================
-- 5. VERIFICATION
-- ============================================================================

-- SELECT tgname, tgrelid::regclass FROM pg_trigger
--  WHERE tgname LIKE 'trg_%count%' ORDER BY 2, 1;
