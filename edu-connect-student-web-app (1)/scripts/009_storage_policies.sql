-- scripts/009_storage_policies.sql
-- Supabase Storage RLS Policies for avatars bucket
-- Run this in Supabase SQL Editor after creating the avatars bucket

-- Enable RLS on storage.objects if not already enabled
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Policy 1: Allow authenticated users to INSERT objects to avatars bucket
-- Objects can only be uploaded if the filename starts with the user's id
CREATE POLICY allow_avatars_insert
  ON storage.objects
  FOR INSERT
  USING ( auth.uid() IS NOT NULL AND bucket_id = 'avatars' AND name LIKE auth.uid() || '%' )
  WITH CHECK ( auth.uid() IS NOT NULL AND bucket_id = 'avatars' AND name LIKE auth.uid() || '%' );

-- Policy 2: Allow anyone to SELECT (view/download) objects from avatars bucket
CREATE POLICY allow_avatars_select
  ON storage.objects
  FOR SELECT
  USING ( bucket_id = 'avatars' );

-- Optional: Allow authenticated users to DELETE their own objects
CREATE POLICY allow_avatars_delete
  ON storage.objects
  FOR DELETE
  USING ( auth.uid() IS NOT NULL AND bucket_id = 'avatars' AND name LIKE auth.uid() || '%' );
