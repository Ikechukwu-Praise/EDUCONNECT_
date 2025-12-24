-- Add missing columns to existing resources table
-- Run this in your Supabase SQL Editor

ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS resource_type TEXT;
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS file_path TEXT;
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS file_name TEXT;
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS file_size BIGINT;
ALTER TABLE public.resources ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT false;

-- Create resources storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('resources', 'resources', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for resources bucket
DROP POLICY IF EXISTS "Resource files are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload resource files" ON storage.objects;

CREATE POLICY "Resource files are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'resources');

CREATE POLICY "Users can upload resource files"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'resources' AND auth.uid() IS NOT NULL);