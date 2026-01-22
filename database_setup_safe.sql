-- Add coins column to existing profiles table if it doesn't exist
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS coins INTEGER DEFAULT 100;

-- Create resources table if it doesn't exist
CREATE TABLE IF NOT EXISTS resources (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT,
  uploader_id UUID REFERENCES auth.users(id),
  subject TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create resource_downloads table if it doesn't exist
CREATE TABLE IF NOT EXISTS resource_downloads (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  resource_id UUID REFERENCES resources(id),
  downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create study_room_participants table if it doesn't exist
CREATE TABLE IF NOT EXISTS study_room_participants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  room_name TEXT,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE resource_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_room_participants ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist and recreate
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Anyone can view resources" ON resources;
DROP POLICY IF EXISTS "Users can insert resources" ON resources;
DROP POLICY IF EXISTS "Users can view own downloads" ON resource_downloads;
DROP POLICY IF EXISTS "Users can insert own downloads" ON resource_downloads;
DROP POLICY IF EXISTS "Users can view own room participation" ON study_room_participants;
DROP POLICY IF EXISTS "Users can insert own room participation" ON study_room_participants;

-- Create policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Anyone can view resources" ON resources FOR SELECT TO authenticated;
CREATE POLICY "Users can insert resources" ON resources FOR INSERT TO authenticated WITH CHECK (auth.uid() = uploader_id);

CREATE POLICY "Users can view own downloads" ON resource_downloads FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own downloads" ON resource_downloads FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own room participation" ON study_room_participants FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own room participation" ON study_room_participants FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Create function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, coins)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', 100)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if it exists and recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();