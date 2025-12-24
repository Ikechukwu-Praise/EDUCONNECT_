-- Resources System Schema
-- Run this in your Supabase SQL Editor

-- Create resources table
CREATE TABLE resources (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  subject_id UUID REFERENCES subjects(id),
  resource_type VARCHAR(50) NOT NULL, -- 'notes', 'assignment', 'past_paper', 'textbook', 'presentation', 'other'
  file_path TEXT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_size BIGINT NOT NULL,
  uploader_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  is_public BOOLEAN DEFAULT false,
  download_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create resource downloads tracking table
CREATE TABLE resource_downloads (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  resource_id UUID REFERENCES resources(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  downloaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(resource_id, user_id)
);

-- Enable RLS
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE resource_downloads ENABLE ROW LEVEL SECURITY;

-- RLS Policies for resources
CREATE POLICY "Public resources are viewable by everyone" ON resources 
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view their own resources" ON resources 
  FOR SELECT USING (auth.uid() = uploader_id);

CREATE POLICY "Users can insert their own resources" ON resources 
  FOR INSERT WITH CHECK (auth.uid() = uploader_id);

CREATE POLICY "Users can update their own resources" ON resources 
  FOR UPDATE USING (auth.uid() = uploader_id);

CREATE POLICY "Users can delete their own resources" ON resources 
  FOR DELETE USING (auth.uid() = uploader_id);

-- RLS Policies for resource downloads
CREATE POLICY "Users can view their own downloads" ON resource_downloads 
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own downloads" ON resource_downloads 
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Create storage bucket for resources
INSERT INTO storage.buckets (id, name, public) VALUES ('resources', 'resources', false);

-- Storage policies
CREATE POLICY "Users can upload resources" ON storage.objects 
  FOR INSERT WITH CHECK (bucket_id = 'resources' AND auth.role() = 'authenticated');

CREATE POLICY "Users can view resources" ON storage.objects 
  FOR SELECT USING (bucket_id = 'resources' AND auth.role() = 'authenticated');

CREATE POLICY "Users can delete their own resources" ON storage.objects 
  FOR DELETE USING (bucket_id = 'resources' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Function to increment download count
CREATE OR REPLACE FUNCTION increment_download_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE resources 
  SET download_count = download_count + 1 
  WHERE id = NEW.resource_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to increment download count
CREATE TRIGGER increment_download_count_trigger
  AFTER INSERT ON resource_downloads
  FOR EACH ROW
  EXECUTE FUNCTION increment_download_count();

-- Insert sample resources (optional)
INSERT INTO resources (title, description, subject_id, resource_type, file_path, file_name, file_size, uploader_id, is_public) VALUES
('Calculus Notes Chapter 1', 'Comprehensive notes on limits and derivatives', 
 (SELECT id FROM subjects WHERE name = 'Mathematics' LIMIT 1), 
 'notes', 'sample/calculus-notes.pdf', 'calculus-notes.pdf', 1024000, 
 (SELECT id FROM profiles LIMIT 1), true),
 
('Physics Lab Report Template', 'Standard template for physics lab reports', 
 (SELECT id FROM subjects WHERE name = 'Physics' LIMIT 1), 
 'assignment', 'sample/lab-report-template.docx', 'lab-report-template.docx', 512000, 
 (SELECT id FROM profiles LIMIT 1), true),
 
('Chemistry Past Paper 2023', 'Previous year chemistry examination paper', 
 (SELECT id FROM subjects WHERE name = 'Chemistry' LIMIT 1), 
 'past_paper', 'sample/chemistry-2023.pdf', 'chemistry-2023.pdf', 2048000, 
 (SELECT id FROM profiles LIMIT 1), true);