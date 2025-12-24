-- Fix Profile Schema - Add missing tables and columns
-- Run this in your Supabase SQL Editor

-- Add missing columns to profiles table
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS profile_photo_url TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS country TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS class_level TEXT;

-- Create user_subjects table for subject selections
CREATE TABLE IF NOT EXISTS public.user_subjects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, subject_id)
);

-- Create class_levels table for country-specific education levels
CREATE TABLE IF NOT EXISTS public.class_levels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country TEXT NOT NULL,
  level_name TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create friendships table
CREATE TABLE IF NOT EXISTS public.friendships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  addressee_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(requester_id, addressee_id)
);

-- Create achievements table
CREATE TABLE IF NOT EXISTS public.achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  points INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_achievements table
CREATE TABLE IF NOT EXISTS public.user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES public.achievements(id) ON DELETE CASCADE,
  earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, achievement_id)
);

-- Enable RLS on new tables
ALTER TABLE public.user_subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.class_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_subjects
CREATE POLICY "Users can view all subject selections" ON public.user_subjects FOR SELECT USING (true);
CREATE POLICY "Users can manage own subject selections" ON public.user_subjects FOR ALL USING (auth.uid() = user_id);

-- RLS Policies for class_levels
CREATE POLICY "Anyone can view class levels" ON public.class_levels FOR SELECT USING (true);

-- RLS Policies for friendships
CREATE POLICY "Users can view friendships they're part of" ON public.friendships FOR SELECT USING (auth.uid() = requester_id OR auth.uid() = addressee_id);
CREATE POLICY "Users can create friend requests" ON public.friendships FOR INSERT WITH CHECK (auth.uid() = requester_id);
CREATE POLICY "Users can update friendships they're part of" ON public.friendships FOR UPDATE USING (auth.uid() = requester_id OR auth.uid() = addressee_id);

-- RLS Policies for achievements
CREATE POLICY "Anyone can view achievements" ON public.achievements FOR SELECT USING (true);

-- RLS Policies for user_achievements
CREATE POLICY "Users can view all user achievements" ON public.user_achievements FOR SELECT USING (true);
CREATE POLICY "Users can manage own achievements" ON public.user_achievements FOR ALL USING (auth.uid() = user_id);

-- Insert sample class levels
INSERT INTO public.class_levels (country, level_name, sort_order) VALUES
('United States', 'Elementary School', 1),
('United States', 'Middle School', 2),
('United States', 'High School', 3),
('United States', 'College Freshman', 4),
('United States', 'College Sophomore', 5),
('United States', 'College Junior', 6),
('United States', 'College Senior', 7),
('United States', 'Graduate School', 8),
('United Kingdom', 'Primary School', 1),
('United Kingdom', 'Secondary School', 2),
('United Kingdom', 'A-Levels', 3),
('United Kingdom', 'University Year 1', 4),
('United Kingdom', 'University Year 2', 5),
('United Kingdom', 'University Year 3', 6),
('United Kingdom', 'Postgraduate', 7),
('India', 'Primary School (1-5)', 1),
('India', 'Middle School (6-8)', 2),
('India', 'High School (9-10)', 3),
('India', 'Higher Secondary (11-12)', 4),
('India', 'Undergraduate', 5),
('India', 'Postgraduate', 6),
('Australia', 'Primary School', 1),
('Australia', 'High School', 2),
('Australia', 'Year 12', 3),
('Australia', 'University', 4),
('Australia', 'Postgraduate', 5),
('Canada', 'Elementary School', 1),
('Canada', 'High School', 2),
('Canada', 'University', 3),
('Canada', 'Graduate School', 4),
('Netherlands', 'Basisschool', 1),
('Netherlands', 'Middelbare School', 2),
('Netherlands', 'HBO/University', 3),
('Netherlands', 'Master/PhD', 4)
ON CONFLICT DO NOTHING;