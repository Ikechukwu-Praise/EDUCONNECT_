-- Fix Study Rooms Schema to match the application expectations
-- Run this in your Supabase SQL Editor

-- First, ensure subjects table exists with proper structure
CREATE TABLE IF NOT EXISTS public.subjects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  code TEXT NOT NULL UNIQUE,
  description TEXT,
  icon TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert basic subjects if they don't exist
INSERT INTO public.subjects (name, code, description, icon) VALUES
  ('Computer Science', 'CS101', 'Introduction to programming and algorithms', '💻'),
  ('Mathematics', 'MATH101', 'Calculus and linear algebra', '📐'),
  ('Physics', 'PHYS101', 'Classical mechanics and electromagnetism', '⚡'),
  ('Biology', 'BIO101', 'Cell biology and genetics', '🧬'),
  ('Chemistry', 'CHEM101', 'Organic and inorganic chemistry', '🧪'),
  ('English Literature', 'ENG101', 'Classic and modern literature analysis', '📚'),
  ('History', 'HIST101', 'World history and civilizations', '🌍'),
  ('Psychology', 'PSY101', 'Cognitive psychology and behavior', '🧠')
ON CONFLICT (code) DO NOTHING;

-- Drop existing study rooms tables if they exist
DROP TABLE IF EXISTS public.study_room_participants CASCADE;
DROP TABLE IF EXISTS public.study_rooms CASCADE;

-- Create study_rooms table with correct structure
CREATE TABLE public.study_rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  subject_id UUID REFERENCES public.subjects(id) ON DELETE SET NULL,
  creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  max_participants INTEGER NOT NULL DEFAULT 5,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'full', 'closed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create study_room_participants table
CREATE TABLE public.study_room_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES public.study_rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(room_id, user_id)
);

-- Enable RLS
ALTER TABLE public.study_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_room_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

-- RLS Policies for subjects
DROP POLICY IF EXISTS "Anyone can view subjects" ON public.subjects;
CREATE POLICY "Anyone can view subjects" ON public.subjects FOR SELECT USING (true);

-- RLS Policies for study_rooms
DROP POLICY IF EXISTS "Study rooms are viewable by everyone" ON public.study_rooms;
DROP POLICY IF EXISTS "Users can create their own rooms" ON public.study_rooms;
DROP POLICY IF EXISTS "Users can update their own rooms" ON public.study_rooms;
DROP POLICY IF EXISTS "Users can delete their own rooms" ON public.study_rooms;

CREATE POLICY "Study rooms are viewable by everyone" ON public.study_rooms FOR SELECT USING (true);
CREATE POLICY "Users can create their own rooms" ON public.study_rooms FOR INSERT WITH CHECK (auth.uid() = creator_id);
CREATE POLICY "Users can update their own rooms" ON public.study_rooms FOR UPDATE USING (auth.uid() = creator_id);
CREATE POLICY "Users can delete their own rooms" ON public.study_rooms FOR DELETE USING (auth.uid() = creator_id);

-- RLS Policies for study_room_participants
DROP POLICY IF EXISTS "Room participants are viewable by everyone" ON public.study_room_participants;
DROP POLICY IF EXISTS "Users can join rooms" ON public.study_room_participants;
DROP POLICY IF EXISTS "Users can leave rooms" ON public.study_room_participants;

CREATE POLICY "Room participants are viewable by everyone" ON public.study_room_participants FOR SELECT USING (true);
CREATE POLICY "Users can join rooms" ON public.study_room_participants FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can leave rooms" ON public.study_room_participants FOR DELETE USING (auth.uid() = user_id);

-- Function to update room status based on participant count
CREATE OR REPLACE FUNCTION update_room_status()
RETURNS TRIGGER AS $$
DECLARE
  participant_count INTEGER;
  max_participants INTEGER;
BEGIN
  -- Get current participant count and max participants
  SELECT COUNT(*), sr.max_participants 
  INTO participant_count, max_participants
  FROM study_room_participants srp
  JOIN study_rooms sr ON sr.id = srp.room_id
  WHERE srp.room_id = COALESCE(NEW.room_id, OLD.room_id)
  GROUP BY sr.max_participants;
  
  -- Handle case where no participants exist
  IF participant_count IS NULL THEN
    participant_count := 0;
    SELECT sr.max_participants INTO max_participants
    FROM study_rooms sr 
    WHERE sr.id = COALESCE(NEW.room_id, OLD.room_id);
  END IF;
  
  -- Update room status
  IF participant_count >= max_participants THEN
    UPDATE study_rooms SET status = 'full' WHERE id = COALESCE(NEW.room_id, OLD.room_id);
  ELSE
    UPDATE study_rooms SET status = 'open' WHERE id = COALESCE(NEW.room_id, OLD.room_id);
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Drop existing triggers
DROP TRIGGER IF EXISTS update_room_status_on_join ON study_room_participants;
DROP TRIGGER IF EXISTS update_room_status_on_leave ON study_room_participants;

-- Create triggers to update room status
CREATE TRIGGER update_room_status_on_join
  AFTER INSERT ON study_room_participants
  FOR EACH ROW
  EXECUTE FUNCTION update_room_status();

CREATE TRIGGER update_room_status_on_leave
  AFTER DELETE ON study_room_participants
  FOR EACH ROW
  EXECUTE FUNCTION update_room_status();