-- Add missing profile_photo_url column to profiles table
-- Run this in your Supabase SQL Editor

ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS profile_photo_url TEXT;