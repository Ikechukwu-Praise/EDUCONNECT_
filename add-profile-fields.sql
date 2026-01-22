-- Add country and class_level columns to profiles table
-- Run this in your Supabase SQL Editor

ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS country VARCHAR(100),
ADD COLUMN IF NOT EXISTS class_level VARCHAR(100);

-- Update existing profiles with default values (optional)
UPDATE profiles 
SET country = 'United States', class_level = 'Undergraduate - Year 1' 
WHERE country IS NULL OR class_level IS NULL;