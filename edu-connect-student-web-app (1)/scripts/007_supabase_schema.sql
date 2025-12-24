-- scripts/007_supabase_schema.sql
-- Supabase/Postgres schema for EduConnect (MVP)

-- Profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY DEFAULT auth.uid(),
  full_name text,
  email text UNIQUE,
  country text,
  class_level text,
  selected_subjects text[],
  coins integer DEFAULT 0,
  avatar_url text,
  created_at timestamptz DEFAULT now()
);

-- Subjects by country
CREATE TABLE IF NOT EXISTS subjects_by_country (
  id serial PRIMARY KEY,
  country text NOT NULL,
  subject text NOT NULL
);

-- Resources table
CREATE TABLE IF NOT EXISTS resources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  subject text,
  country text,
  price_coins integer DEFAULT 0,
  file_url text,
  public boolean DEFAULT true,
  created_by uuid REFERENCES profiles(id) ON DELETE SET NULL,
  created_at timestamptz DEFAULT now()
);

-- Purchases
CREATE TABLE IF NOT EXISTS purchases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  resource_id uuid REFERENCES resources(id) ON DELETE SET NULL,
  coins_spent integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Study rooms
CREATE TABLE IF NOT EXISTS study_rooms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  subject text,
  host_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  jitsi_room text,
  is_private boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS study_room_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id uuid REFERENCES study_rooms(id) ON DELETE CASCADE,
  profile_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at timestamptz DEFAULT now()
);

-- Basic seed data for supported countries (no Nigeria)
INSERT INTO subjects_by_country (country, subject) VALUES
('United States','Mathematics'),
('United States','Physics'),
('United Kingdom','English Literature'),
('India','IIT-JEE Prep'),
('India','NEET Prep'),
('Australia','Biology')
ON CONFLICT DO NOTHING;

-- Notes: enable RLS and policies in Supabase dashboard to protect premium resources.
