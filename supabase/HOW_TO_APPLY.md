# Applying the community migration

Everything here is done by hand in the Supabase dashboard. There is no
Supabase CLI wired into this repo, and `supabase/` is gitignored apart from the
files that were force-added, so nothing applies these for you.

Do the steps in order. Total time is about two minutes.

---

## Step 1 - Run migration 004

1. Open the project in Supabase, then **SQL Editor** in the left sidebar.
2. Click **New query**.
3. Open `supabase/004_community_engagement.sql`, copy the whole file, paste it.
4. Click **Run** (or Ctrl+Enter).

Expect `Success. No rows returned`.

Look at the **Messages / Notices** panel underneath the result. One of two
notices will be there:

- `Storage policies for media/community/** created.` - done, skip step 2.
- `Could not create storage policies (...)` - expected on many projects.
  Do step 2. **Everything else in the migration still applied**; the block is
  wrapped precisely so a permissions failure cannot roll back the rest.

The script is idempotent. Re-running it is safe.

### What it changes

| Object | Why |
|---|---|
| `questions.save_count` | Bookmark count. Selected by every question query. |
| `answers.comment_count` | Reply count on each answer. |
| `projects.cover_image_url` | Project screenshot from the upload form. |
| `question_saves` table + RLS | Bookmarks. |
| `question_likes_unique`, `answer_likes_unique` | Missing on your project - 002 declared them inside `CREATE TABLE IF NOT EXISTS`, which was skipped against pre-existing tables. Without them a double tap inserts two like rows. Existing duplicates are removed first. |
| 5 counter triggers + backfill | Keep like / save / answer / comment counts correct without the client doing extra writes. |
| 2 storage policies | Let signed-in users upload to `media/community/**`. |

---

## Step 2 - Storage policies by hand (only if step 1 said it could not)

`storage.objects` is owned by `supabase_storage_admin`. The SQL editor runs as
`postgres`, which on some projects cannot create policies on it. The dashboard
can, because it goes through the storage admin role.

1. **Storage** > **Policies** in the sidebar.
2. Find the **media** bucket. Click **New policy** > **For full customization**.

**Policy A - upload**

- Name: `community_attachments_insert`
- Allowed operation: **INSERT**
- Target roles: `authenticated`
- WITH CHECK expression:

```sql
bucket_id = 'media' AND (storage.foldername(name))[1] = 'community'
```

**Policy B - delete own**

- Name: `community_attachments_delete_own`
- Allowed operation: **DELETE**
- Target roles: `authenticated`
- USING expression:

```sql
bucket_id = 'media'
AND (storage.foldername(name))[1] = 'community'
AND owner = auth.uid()
```

Both are scoped to the `community/` prefix, so they cannot touch the existing
`events/`, `banners/` or `speaker_images/` folders.

Reads need no policy - `media` is already a public bucket.

---

## Step 3 - Verify

New query in the SQL Editor, paste `supabase/verify_community_schema.sql`, Run.

**Zero rows returned means everything passed.** The column check only lists
failures. Any row that comes back names the missing object and which migration
was supposed to add it.

To also see the passing rows, comment out this line in the script:

```sql
WHERE c.column_name IS NULL   -- comment out this line to see PASS rows too
```

---

## Step 4 - Check it from the app

1. Reinstall the debug APK (`flutter build apk --debug`, or `flutter run`).
2. Open **Community**. The feed should load instead of showing an error.
3. **Ask a question** > **Browse files**, pick an image. It should upload
   rather than reporting "Bucket not found" or a 403.
4. Post the question. You should land on **Question posted**, not on a
   "community not found" screen.

### If something still fails

The app now names the cause instead of showing a generic message:

| On screen | Meaning |
|---|---|
| "The app is ahead of the database. Apply the pending migration" | Step 1 did not take. Re-run it and read the Messages panel. |
| "Storage bucket ... was not found" | Wrong bucket name. Should be `media`. |
| "new row violates row-level security policy" | Step 2 is missing. |
| "You need to be signed in to do that." | No session - sign in first. |
