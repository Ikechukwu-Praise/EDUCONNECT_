-- Fix Resources Upload System
-- Run this in your Supabase SQL Editor

-- Create resources table with correct structure
CREATE TABLE IF NOT EXISTS public.resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  subject_id UUID REFERENCES public.subjects(id) ON DELETE SET NULL,
  resource_type TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_size BIGINT NOT NULL,
  uploader_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  is_public BOOLEAN DEFAULT false,
  downloads INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;

-- RLS Policies for resources
DROP POLICY IF EXISTS "Anyone can view public resources" ON public.resources;
DROP POLICY IF EXISTS "Users can upload resources" ON public.resources;
DROP POLICY IF EXISTS "Users can update own resources" ON public.resources;

CREATE POLICY "Anyone can view public resources" ON public.resources FOR SELECT USING (is_public = true OR auth.uid() = uploader_id);
CREATE POLICY "Users can upload resources" ON public.resources FOR INSERT WITH CHECK (auth.uid() = uploader_id);
CREATE POLICY "Users can update own resources" ON public.resources FOR UPDATE USING (auth.uid() = uploader_id);

-- Create resources storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('resources', 'resources', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for resources bucket
DROP POLICY IF EXISTS "Resource files are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload resource files" ON storage.objects;
DROP POLICY IF EXISTS "Users can update own resource files" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete own resource files" ON storage.objects;

CREATE POLICY "Resource files are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'resources');

CREATE POLICY "Users can upload resource files"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'resources' AND auth.uid() IS NOT NULL);

CREATE POLICY "Users can update own resource files"
ON storage.objects FOR UPDATE
USING (bucket_id = 'resources' AND auth.uid() IS NOT NULL);

CREATE POLICY "Users can delete own resource files"
ON storage.objects FOR DELETE
USING (bucket_id = 'resources' AND auth.uid() IS NOT NULL);