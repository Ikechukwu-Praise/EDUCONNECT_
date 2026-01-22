-- Update existing users with default values
-- Run this in your Supabase SQL Editor

UPDATE public.profiles 
SET 
  country = 'United States',
  class_level = 'Undergraduate - Year 1'
WHERE country IS NULL OR country = '' OR class_level IS NULL OR class_level = '';