-- Performance optimization indexes
-- Run these in your Supabase SQL editor

-- Profiles table optimization
CREATE INDEX IF NOT EXISTS idx_profiles_id ON profiles(id);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);

-- Resources table optimization  
CREATE INDEX IF NOT EXISTS idx_resources_subject_id ON resources(subject_id);
CREATE INDEX IF NOT EXISTS idx_resources_uploader_id ON resources(uploader_id);
CREATE INDEX IF NOT EXISTS idx_resources_created_at ON resources(created_at DESC);

-- Resource downloads optimization
CREATE INDEX IF NOT EXISTS idx_resource_downloads_user_id ON resource_downloads(user_id);
CREATE INDEX IF NOT EXISTS idx_resource_downloads_resource_id ON resource_downloads(resource_id);

-- Friendships optimization
CREATE INDEX IF NOT EXISTS idx_friendships_requester ON friendships(requester_id);
CREATE INDEX IF NOT EXISTS idx_friendships_addressee ON friendships(addressee_id);
CREATE INDEX IF NOT EXISTS idx_friendships_status ON friendships(status);

-- Study rooms optimization
CREATE INDEX IF NOT EXISTS idx_study_rooms_creator ON study_rooms(creator_id);
CREATE INDEX IF NOT EXISTS idx_study_room_participants_user ON study_room_participants(user_id);
CREATE INDEX IF NOT EXISTS idx_study_room_participants_room ON study_room_participants(room_id);

-- User subjects optimization
CREATE INDEX IF NOT EXISTS idx_user_subjects_user_id ON user_subjects(user_id);
CREATE INDEX IF NOT EXISTS idx_user_subjects_subject_id ON user_subjects(subject_id);