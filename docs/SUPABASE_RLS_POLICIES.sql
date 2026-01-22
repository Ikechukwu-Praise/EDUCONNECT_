-- docs/SUPABASE_RLS_POLICIES.sql
-- Row-Level Security (RLS) policies for EduConnect.
-- Apply these in Supabase SQL Editor after running 007_supabase_schema.sql

-- Enable RLS on tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_room_participants ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can only read/update their own profile
CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Resources: Public resources visible to all authenticated users; premium resources require coin verification
CREATE POLICY "Public resources visible to all"
  ON resources FOR SELECT
  USING (public = true);

CREATE POLICY "Premium resources visible after purchase"
  ON resources FOR SELECT
  USING (
    public = false 
    AND EXISTS (
      SELECT 1 FROM purchases 
      WHERE purchases.profile_id = auth.uid() 
      AND purchases.resource_id = resources.id
    )
  );

CREATE POLICY "Resource creators can view own resources"
  ON resources FOR SELECT
  USING (created_by = auth.uid());

CREATE POLICY "Authenticated users can insert resources"
  ON resources FOR INSERT
  WITH CHECK (auth.role() = 'authenticated' AND created_by = auth.uid());

-- Purchases: Users can only view their own purchases
CREATE POLICY "Users can view own purchases"
  ON purchases FOR SELECT
  USING (profile_id = auth.uid());

CREATE POLICY "Users can create own purchases"
  ON purchases FOR INSERT
  WITH CHECK (profile_id = auth.uid());

-- Study Rooms: All authenticated users can view; hosts can delete own rooms
CREATE POLICY "Authenticated users can view rooms"
  ON study_rooms FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Room hosts can delete own rooms"
  ON study_rooms FOR DELETE
  USING (host_id = auth.uid());

CREATE POLICY "Authenticated users can create rooms"
  ON study_rooms FOR INSERT
  WITH CHECK (auth.role() = 'authenticated' AND host_id = auth.uid());

-- Study Room Participants: Authenticated users can manage own participation
CREATE POLICY "Users can view room participants"
  ON study_room_participants FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Users can join rooms"
  ON study_room_participants FOR INSERT
  WITH CHECK (profile_id = auth.uid());

CREATE POLICY "Users can leave own room participation"
  ON study_room_participants FOR DELETE
  USING (profile_id = auth.uid());

-- Notes:
-- - Enable RLS in Supabase Dashboard: Authentication → Policies
-- - Adjust policies based on your business rules (e.g., coin requirements, country restrictions)
-- - Test policies in Supabase SQL Editor before deploying to production
