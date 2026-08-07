-- Let project owners write their own tech stack.
--
-- project_tech_stack has RLS enabled (schema.sql) but rls_policies.sql only
-- grants it:
--   project_tech_stack_read   SELECT to authenticated
--   project_tech_stack_admin  ALL    to admins
--
-- So a normal member submitting a project through the Upload Project form got
-- the projects row inserted (projects_owner_manage allows that) and then hit
-- 42501 on the tech-stack insert. The user saw a failure for a project that
-- had in fact been created - an orphaned pending_review row with no tech
-- stack, and no way to retry cleanly.
--
-- Ownership is derived from the parent project rather than stored again here,
-- so this cannot grant access to anyone else's project.

DROP POLICY IF EXISTS "project_tech_stack_owner_write" ON public.project_tech_stack;
CREATE POLICY "project_tech_stack_owner_write" ON public.project_tech_stack
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.projects p
       WHERE p.id = project_tech_stack.project_id
         AND p.owner_uid = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.projects p
       WHERE p.id = project_tech_stack.project_id
         AND p.owner_uid = auth.uid()
    )
  );

-- ============================================================================
-- Verification
-- ============================================================================

-- SELECT policyname, cmd, roles
--   FROM pg_policies
--  WHERE schemaname = 'public' AND tablename = 'project_tech_stack'
--  ORDER BY policyname;
