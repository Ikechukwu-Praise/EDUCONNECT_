-- Fix profile creation trigger to preserve signup data
-- Run this in your Supabase SQL Editor

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, university, country, class_level, coins)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'full_name', 'New Student'),
    COALESCE(new.raw_user_meta_data->>'university', ''),
    COALESCE(new.raw_user_meta_data->>'country', ''),
    COALESCE(new.raw_user_meta_data->>'class_level', ''),
    50
  )
  ON CONFLICT (id) DO UPDATE SET
    full_name = COALESCE(new.raw_user_meta_data->>'full_name', profiles.full_name),
    university = COALESCE(new.raw_user_meta_data->>'university', profiles.university),
    country = COALESCE(new.raw_user_meta_data->>'country', profiles.country),
    class_level = COALESCE(new.raw_user_meta_data->>'class_level', profiles.class_level);
  RETURN new;
END;
$$;