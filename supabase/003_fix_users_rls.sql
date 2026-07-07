-- Fix Users Table RLS for Public Reads
-- Allows foreign key joins to work properly

-- Enable RLS on users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Allow anyone to select public user profiles (needed for author joins)
DROP POLICY IF EXISTS "users_select_policy" ON public.users;
CREATE POLICY "users_select_policy" ON public.users
  FOR SELECT USING (true);

-- Allow users to update only their own profile
DROP POLICY IF EXISTS "users_update_policy" ON public.users;
CREATE POLICY "users_update_policy" ON public.users
  FOR UPDATE USING (auth.uid() = uid)
  WITH CHECK (auth.uid() = uid);

-- Allow users to insert their own profile
DROP POLICY IF EXISTS "users_insert_policy" ON public.users;
CREATE POLICY "users_insert_policy" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = uid);
