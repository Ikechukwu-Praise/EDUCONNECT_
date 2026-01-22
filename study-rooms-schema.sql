-- Study Rooms System Schema
-- Run this in your Supabase SQL Editor

-- Study Rooms Table
CREATE TABLE study_rooms (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  subject_id UUID REFERENCES subjects(id),
  creator_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  max_participants INTEGER DEFAULT 5,
  status VARCHAR(20) DEFAULT 'open', -- 'open', 'full', 'closed'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Study Room Participants Table
CREATE TABLE study_room_participants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  room_id UUID REFERENCES study_rooms(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(room_id, user_id)
);

-- Enable RLS
ALTER TABLE study_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_room_participants ENABLE ROW LEVEL SECURITY;

-- RLS Policies for study_rooms
CREATE POLICY "Study rooms are viewable by everyone" ON study_rooms FOR SELECT USING (true);
CREATE POLICY "Users can create their own rooms" ON study_rooms FOR INSERT WITH CHECK (auth.uid() = creator_id);
CREATE POLICY "Users can update their own rooms" ON study_rooms FOR UPDATE USING (auth.uid() = creator_id);
CREATE POLICY "Users can delete their own rooms" ON study_rooms FOR DELETE USING (auth.uid() = creator_id);

-- RLS Policies for study_room_participants
CREATE POLICY "Room participants are viewable by everyone" ON study_room_participants FOR SELECT USING (true);
CREATE POLICY "Users can join rooms" ON study_room_participants FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can leave rooms" ON study_room_participants FOR DELETE USING (auth.uid() = user_id);

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
  
  -- Update room status
  IF participant_count >= max_participants THEN
    UPDATE study_rooms SET status = 'full' WHERE id = COALESCE(NEW.room_id, OLD.room_id);
  ELSE
    UPDATE study_rooms SET status = 'open' WHERE id = COALESCE(NEW.room_id, OLD.room_id);
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Triggers to update room status
CREATE TRIGGER update_room_status_on_join
  AFTER INSERT ON study_room_participants
  FOR EACH ROW
  EXECUTE FUNCTION update_room_status();

CREATE TRIGGER update_room_status_on_leave
  AFTER DELETE ON study_room_participants
  FOR EACH ROW
  EXECUTE FUNCTION update_room_status();

-- Insert sample study rooms
INSERT INTO study_rooms (name, description, subject_id, creator_id, max_participants) VALUES
('Math Study Group', 'Working on calculus problems together', 
 (SELECT id FROM subjects WHERE name = 'Mathematics' LIMIT 1), 
 (SELECT id FROM profiles LIMIT 1), 8),
 
('Physics Lab Discussion', 'Discussing quantum mechanics concepts', 
 (SELECT id FROM subjects WHERE name = 'Physics' LIMIT 1), 
 (SELECT id FROM profiles LIMIT 1), 6),
 
('Chemistry Exam Prep', 'Preparing for organic chemistry exam', 
 (SELECT id FROM subjects WHERE name = 'Chemistry' LIMIT 1), 
 (SELECT id FROM profiles LIMIT 1), 10);