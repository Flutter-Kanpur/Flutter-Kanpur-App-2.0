-- Community module schema verification.
--
-- Read-only. Paste into the Supabase SQL editor and run.
--
-- The first row is always a SUMMARY. It reads either
--   ALL CHECKS PASSED        -> 002 and 004 are both fully applied
--   N CHECK(S) FAILED        -> the failing rows are listed directly beneath
--
-- This script always returns rows, so "no rows returned" means the script did
-- not run, never that everything is fine.

WITH required_columns(tbl, col, added_by) AS (
  VALUES
    -- questions: base schema
    ('questions',    'id',              'base'),
    ('questions',    'title',           'base'),
    ('questions',    'body',            'base'),
    ('questions',    'author_uid',      'base'),
    ('questions',    'status',          'base'),
    ('questions',    'answer_count',    'base'),
    ('questions',    'is_deleted',      'base'),
    ('questions',    'created_at',      'base'),
    -- questions: added by 002
    ('questions',    'category',        '002'),
    ('questions',    'image_url',       '002'),
    ('questions',    'like_count',      '002'),
    ('questions',    'view_count',      '002'),
    ('questions',    'tags',            '002'),
    -- questions: added by 004
    ('questions',    'save_count',      '004'),

    -- answers: base schema
    ('answers',      'id',              'base'),
    ('answers',      'question_id',     'base'),
    ('answers',      'author_uid',      'base'),
    ('answers',      'body',            'base'),
    ('answers',      'is_deleted',      'base'),
    ('answers',      'created_at',      'base'),
    -- answers: added by 002
    ('answers',      'image_url',       '002'),
    ('answers',      'code_snippet',    '002'),
    ('answers',      'like_count',      '002'),
    ('answers',      'view_count',      '002'),
    -- answers: added by 004
    ('answers',      'comment_count',   '004'),

    -- projects
    ('projects',     'github_url',      'base'),
    ('projects',     'live_url',        'base'),
    ('projects',     'summary',         'base'),
    ('projects',     'cover_image_url', '004'),

    -- join tables
    ('question_likes',  'question_id',  '002'),
    ('question_likes',  'user_uid',     '002'),
    ('answer_likes',    'answer_id',    '002'),
    ('answer_likes',    'user_uid',     '002'),
    ('answer_comments', 'answer_id',    '002'),
    ('answer_comments', 'author_uid',   '002'),
    ('answer_comments', 'body',         '002'),
    ('answer_comments', 'is_deleted',   '002'),
    ('question_saves',  'question_id',  '004'),
    ('question_saves',  'user_uid',     '004'),

    -- notifications (community bell)
    ('notifications', 'user_uid',       'base'),
    ('notifications', 'module',         'base'),
    ('notifications', 'title',          'base'),
    ('notifications', 'body',           'base'),
    ('notifications', 'read_at',        'base')
),

checks AS (
  -- Columns -----------------------------------------------------------------
  SELECT
    '1. COLUMN'           AS check_group,
    r.added_by            AS migration,
    r.tbl || '.' || r.col AS object,
    CASE WHEN c.column_name IS NULL THEN 'FAIL - missing' ELSE 'PASS' END AS result
  FROM required_columns r
  LEFT JOIN information_schema.columns c
         ON c.table_schema = 'public'
        AND c.table_name   = r.tbl
        AND c.column_name  = r.col

  UNION ALL

  -- Tables ------------------------------------------------------------------
  SELECT
    '2. TABLE', m.added_by, m.tbl,
    CASE WHEN t.table_name IS NULL THEN 'FAIL - missing' ELSE 'PASS' END
  FROM (VALUES
          ('questions','base'), ('answers','base'), ('projects','base'),
          ('project_tech_stack','base'), ('community_memberships','base'),
          ('user_skills','base'), ('users','base'), ('notifications','base'),
          ('question_likes','002'), ('answer_likes','002'),
          ('answer_comments','002'), ('question_saves','004')
       ) AS m(tbl, added_by)
  LEFT JOIN information_schema.tables t
         ON t.table_schema = 'public' AND t.table_name = m.tbl

  UNION ALL

  -- Unique constraints ------------------------------------------------------
  SELECT
    '3. UNIQUE', m.added_by, m.conname,
    CASE WHEN c.conname IS NULL THEN 'FAIL - missing' ELSE 'PASS' END
  FROM (VALUES
          ('question_likes_unique','002'),
          ('answer_likes_unique','002'),
          ('question_saves_unique','004')
       ) AS m(conname, added_by)
  LEFT JOIN pg_constraint c ON c.conname = m.conname

  UNION ALL

  -- Counter triggers --------------------------------------------------------
  SELECT
    '4. TRIGGER', '004', m.tgname,
    CASE WHEN t.tgname IS NULL THEN 'FAIL - missing' ELSE 'PASS' END
  FROM (VALUES
          ('trg_question_likes_count'),
          ('trg_question_saves_count'),
          ('trg_answer_likes_count'),
          ('trg_answer_comments_count'),
          ('trg_answers_question_count')
       ) AS m(tgname)
  LEFT JOIN pg_trigger t ON t.tgname = m.tgname AND NOT t.tgisinternal

  UNION ALL

  -- Foreign keys the PostgREST embeds depend on -----------------------------
  -- e.g. author:users!author_uid(...) only resolves if this FK exists.
  SELECT
    '5. FOREIGN KEY', 'base/002', m.conname,
    CASE WHEN c.conname IS NULL THEN 'FAIL - missing' ELSE 'PASS' END
  FROM (VALUES
          ('questions_author_uid_fkey'),
          ('answers_author_uid_fkey'),
          ('answer_comments_author_uid_fkey'),
          ('projects_owner_uid_fkey'),
          ('project_tech_stack_project_id_fkey'),
          ('community_memberships_user_uid_fkey'),
          ('user_skills_user_uid_fkey')
       ) AS m(conname)
  LEFT JOIN pg_constraint c ON c.conname = m.conname

  UNION ALL

  -- Storage policies for media/community/** ---------------------------------
  -- Created by 004, or by hand in Storage > Policies when the SQL editor
  -- lacks ownership of storage.objects.
  SELECT
    '6. STORAGE POLICY', '004', m.polname,
    CASE WHEN p.policyname IS NULL THEN 'FAIL - missing' ELSE 'PASS' END
  FROM (VALUES
          ('community_attachments_insert'),
          ('community_attachments_delete_own')
       ) AS m(polname)
  LEFT JOIN pg_policies p
         ON p.schemaname = 'storage'
        AND p.tablename  = 'objects'
        AND p.policyname = m.polname
)

SELECT check_group, migration, object, result
FROM (
  -- Summary first, then failures, then everything that passed.
  SELECT 0 AS sort_key, 'SUMMARY' AS check_group, '' AS migration,
         CASE WHEN (SELECT count(*) FROM checks WHERE result <> 'PASS') = 0
              THEN 'ALL CHECKS PASSED'
              ELSE (SELECT count(*) FROM checks WHERE result <> 'PASS')::text
                   || ' CHECK(S) FAILED - see rows below'
         END AS object,
         CASE WHEN (SELECT count(*) FROM checks WHERE result <> 'PASS') = 0
              THEN 'PASS' ELSE 'FAIL' END AS result
  UNION ALL
  SELECT 1, check_group, migration, object, result
    FROM checks WHERE result <> 'PASS'
  UNION ALL
  SELECT 2, check_group, migration, object, result
    FROM checks WHERE result = 'PASS'
) ordered
ORDER BY sort_key, check_group, object;


-- ---------------------------------------------------------------------------
-- Counter drift check. Should return no rows once 004 has run.
-- ---------------------------------------------------------------------------
-- SELECT q.id, q.title,
--        q.like_count   AS stored_likes,
--        (SELECT count(*) FROM public.question_likes l WHERE l.question_id = q.id) AS real_likes,
--        q.answer_count AS stored_answers,
--        (SELECT count(*) FROM public.answers a
--          WHERE a.question_id = q.id AND NOT a.is_deleted) AS real_answers
--   FROM public.questions q
--  WHERE q.like_count <> (SELECT count(*) FROM public.question_likes l WHERE l.question_id = q.id)
--     OR q.answer_count <> (SELECT count(*) FROM public.answers a
--                            WHERE a.question_id = q.id AND NOT a.is_deleted);
