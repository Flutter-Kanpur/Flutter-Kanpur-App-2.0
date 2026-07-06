-- Community Forum Tables Migration
-- Fixes missing columns and creates required tables for forum features

-- ============================================================================
-- 1. UPDATE questions TABLE - Add missing columns
-- ============================================================================

ALTER TABLE public.questions
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'general',
ADD COLUMN IF NOT EXISTS image_url TEXT,
ADD COLUMN IF NOT EXISTS like_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}';

-- Create index on author_uid for faster queries
CREATE INDEX IF NOT EXISTS idx_questions_author_uid ON public.questions(author_uid);
CREATE INDEX IF NOT EXISTS idx_questions_created_at ON public.questions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_questions_category ON public.questions(category);

-- ============================================================================
-- 2. UPDATE answers TABLE - Add missing columns
-- ============================================================================

ALTER TABLE public.answers
ADD COLUMN IF NOT EXISTS image_url TEXT,
ADD COLUMN IF NOT EXISTS code_snippet TEXT,
ADD COLUMN IF NOT EXISTS like_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0;

-- Create index on author_uid for faster queries
CREATE INDEX IF NOT EXISTS idx_answers_author_uid ON public.answers(author_uid);
CREATE INDEX IF NOT EXISTS idx_answers_question_id ON public.answers(question_id);
CREATE INDEX IF NOT EXISTS idx_answers_created_at ON public.answers(created_at DESC);

-- ============================================================================
-- 3. CREATE question_likes TABLE - Track question likes
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.question_likes (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL,
  user_uid UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),

  CONSTRAINT question_likes_pkey PRIMARY KEY (id),
  CONSTRAINT question_likes_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE,
  CONSTRAINT question_likes_user_uid_fkey FOREIGN KEY (user_uid) REFERENCES public.users(uid) ON DELETE CASCADE,
  CONSTRAINT question_likes_unique UNIQUE(question_id, user_uid)
);

CREATE INDEX IF NOT EXISTS idx_question_likes_question ON public.question_likes(question_id);
CREATE INDEX IF NOT EXISTS idx_question_likes_user ON public.question_likes(user_uid);

-- ============================================================================
-- 4. CREATE answer_likes TABLE - Track answer likes
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.answer_likes (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  answer_id UUID NOT NULL,
  user_uid UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),

  CONSTRAINT answer_likes_pkey PRIMARY KEY (id),
  CONSTRAINT answer_likes_answer_id_fkey FOREIGN KEY (answer_id) REFERENCES public.answers(id) ON DELETE CASCADE,
  CONSTRAINT answer_likes_user_uid_fkey FOREIGN KEY (user_uid) REFERENCES public.users(uid) ON DELETE CASCADE,
  CONSTRAINT answer_likes_unique UNIQUE(answer_id, user_uid)
);

CREATE INDEX IF NOT EXISTS idx_answer_likes_answer ON public.answer_likes(answer_id);
CREATE INDEX IF NOT EXISTS idx_answer_likes_user ON public.answer_likes(user_uid);

-- ============================================================================
-- 5. CREATE answer_comments TABLE - Track answer comments
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.answer_comments (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  answer_id UUID NOT NULL,
  author_uid UUID NOT NULL,
  body TEXT NOT NULL,
  is_deleted BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),

  CONSTRAINT answer_comments_pkey PRIMARY KEY (id),
  CONSTRAINT answer_comments_answer_id_fkey FOREIGN KEY (answer_id) REFERENCES public.answers(id) ON DELETE CASCADE,
  CONSTRAINT answer_comments_author_uid_fkey FOREIGN KEY (author_uid) REFERENCES public.users(uid) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_answer_comments_answer ON public.answer_comments(answer_id);
CREATE INDEX IF NOT EXISTS idx_answer_comments_author ON public.answer_comments(author_uid);

-- ============================================================================
-- 6. CREATE RLS (Row Level Security) POLICIES
-- ============================================================================

-- Enable RLS on all forum tables
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.question_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answer_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answer_comments ENABLE ROW LEVEL SECURITY;

-- Questions: Anyone can view, only author can edit/delete
DROP POLICY IF EXISTS "questions_select_policy" ON public.questions;
CREATE POLICY "questions_select_policy" ON public.questions
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "questions_insert_policy" ON public.questions;
CREATE POLICY "questions_insert_policy" ON public.questions
  FOR INSERT WITH CHECK (auth.uid() = author_uid);

DROP POLICY IF EXISTS "questions_update_policy" ON public.questions;
CREATE POLICY "questions_update_policy" ON public.questions
  FOR UPDATE USING (auth.uid() = author_uid)
  WITH CHECK (auth.uid() = author_uid);

DROP POLICY IF EXISTS "questions_delete_policy" ON public.questions;
CREATE POLICY "questions_delete_policy" ON public.questions
  FOR DELETE USING (auth.uid() = author_uid);

-- Answers: Anyone can view, only author can edit/delete
DROP POLICY IF EXISTS "answers_select_policy" ON public.answers;
CREATE POLICY "answers_select_policy" ON public.answers
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "answers_insert_policy" ON public.answers;
CREATE POLICY "answers_insert_policy" ON public.answers
  FOR INSERT WITH CHECK (auth.uid() = author_uid);

DROP POLICY IF EXISTS "answers_update_policy" ON public.answers;
CREATE POLICY "answers_update_policy" ON public.answers
  FOR UPDATE USING (auth.uid() = author_uid)
  WITH CHECK (auth.uid() = author_uid);

DROP POLICY IF EXISTS "answers_delete_policy" ON public.answers;
CREATE POLICY "answers_delete_policy" ON public.answers
  FOR DELETE USING (auth.uid() = author_uid);

-- Likes: Users can only manage their own likes
DROP POLICY IF EXISTS "question_likes_select_policy" ON public.question_likes;
CREATE POLICY "question_likes_select_policy" ON public.question_likes
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "question_likes_insert_policy" ON public.question_likes;
CREATE POLICY "question_likes_insert_policy" ON public.question_likes
  FOR INSERT WITH CHECK (auth.uid() = user_uid);

DROP POLICY IF EXISTS "question_likes_delete_policy" ON public.question_likes;
CREATE POLICY "question_likes_delete_policy" ON public.question_likes
  FOR DELETE USING (auth.uid() = user_uid);

DROP POLICY IF EXISTS "answer_likes_select_policy" ON public.answer_likes;
CREATE POLICY "answer_likes_select_policy" ON public.answer_likes
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "answer_likes_insert_policy" ON public.answer_likes;
CREATE POLICY "answer_likes_insert_policy" ON public.answer_likes
  FOR INSERT WITH CHECK (auth.uid() = user_uid);

DROP POLICY IF EXISTS "answer_likes_delete_policy" ON public.answer_likes;
CREATE POLICY "answer_likes_delete_policy" ON public.answer_likes
  FOR DELETE USING (auth.uid() = user_uid);

-- Comments: Anyone can view, only author can edit/delete
DROP POLICY IF EXISTS "answer_comments_select_policy" ON public.answer_comments;
CREATE POLICY "answer_comments_select_policy" ON public.answer_comments
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "answer_comments_insert_policy" ON public.answer_comments;
CREATE POLICY "answer_comments_insert_policy" ON public.answer_comments
  FOR INSERT WITH CHECK (auth.uid() = author_uid);

DROP POLICY IF EXISTS "answer_comments_update_policy" ON public.answer_comments;
CREATE POLICY "answer_comments_update_policy" ON public.answer_comments
  FOR UPDATE USING (auth.uid() = author_uid)
  WITH CHECK (auth.uid() = author_uid);

DROP POLICY IF EXISTS "answer_comments_delete_policy" ON public.answer_comments;
CREATE POLICY "answer_comments_delete_policy" ON public.answer_comments
  FOR DELETE USING (auth.uid() = author_uid);

-- ============================================================================
-- 7. VERIFICATION QUERY
-- ============================================================================

-- Run this to verify all foreign keys are set up correctly:
-- SELECT constraint_name, table_name, column_name, foreign_table_name, foreign_column_name
-- FROM information_schema.referential_constraints
-- WHERE table_name IN ('questions', 'answers', 'question_likes', 'answer_likes', 'answer_comments')
-- ORDER BY table_name;
