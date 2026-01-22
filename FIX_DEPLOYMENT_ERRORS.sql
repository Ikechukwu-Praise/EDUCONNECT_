-- FIX_DEPLOYMENT_ERRORS.sql
-- Critical fixes for login/signup database errors
-- Run this in your Supabase SQL Editor immediately

-- 1. Add missing columns to profiles table
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS university TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email TEXT;

-- 2. Drop old trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 3. Create proper trigger function that handles profile creation with all fields
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, university, country, class_level, coins)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'New Student'),
    COALESCE(NEW.raw_user_meta_data->>'university', ''),
    COALESCE(NEW.raw_user_meta_data->>'country', ''),
    COALESCE(NEW.raw_user_meta_data->>'class_level', ''),
    10
  )
  ON CONFLICT (id) DO UPDATE SET
    email = COALESCE(EXCLUDED.email, public.profiles.email),
    full_name = COALESCE(EXCLUDED.full_name, public.profiles.full_name),
    university = COALESCE(EXCLUDED.university, public.profiles.university),
    country = COALESCE(EXCLUDED.country, public.profiles.country),
    class_level = COALESCE(EXCLUDED.class_level, public.profiles.class_level);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- 4. Create new trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- 5. Update RLS policies to allow service role
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to recreate them
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;

-- Recreate policies with proper permissions
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Allow service role to bypass RLS for trigger operations
ALTER TABLE public.profiles FORCE ROW LEVEL SECURITY;

-- 6. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO postgres, authenticated;
GRANT ALL ON public.profiles TO postgres, authenticated;
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO postgres;

-- 7. Verify the profiles table structure
-- SELECT column_name, data_type FROM information_schema.columns 
-- WHERE table_name = 'profiles' ORDER BY ordinal_position;
