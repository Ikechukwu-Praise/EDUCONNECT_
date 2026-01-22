-- Add country column to subjects table
ALTER TABLE subjects ADD COLUMN country VARCHAR(50) DEFAULT 'Global';

-- Add premium resource types and pricing
CREATE TABLE IF NOT EXISTS resource_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  coin_cost INTEGER NOT NULL DEFAULT 0,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Insert resource types with coin costs
INSERT INTO resource_types (name, coin_cost, description) VALUES
('Free Resource', 0, 'Basic study materials available to all users'),
('Chapter Pack', 1, 'Detailed chapter notes and summaries'),
('Practice Pack', 2, 'Practice questions and exercises'),
('Exam Pack', 5, 'Past papers and exam preparation materials'),
('Premium Bundle', 10, 'Complete course materials with all resources');

-- Add resource type and country to resources table
ALTER TABLE resources ADD COLUMN resource_type_id INTEGER REFERENCES resource_types(id) DEFAULT 1;
ALTER TABLE resources ADD COLUMN country VARCHAR(50) DEFAULT 'Global';

-- Clear existing subjects and add country-specific ones
DELETE FROM subjects;

-- United States subjects
INSERT INTO subjects (name, description, icon, country) VALUES
('SAT Preparation', 'Standardized test prep for college admissions', '📚', 'United States'),
('AP Computer Science', 'Advanced Placement computer science curriculum', '💻', 'United States'),
('AP Mathematics', 'Advanced Placement calculus and statistics', '📊', 'United States'),
('AP Physics', 'Advanced Placement physics courses', '⚛️', 'United States'),
('AP Chemistry', 'Advanced Placement chemistry curriculum', '🧪', 'United States'),
('AP Biology', 'Advanced Placement biology studies', '🧬', 'United States'),
('AP History', 'US History and World History AP courses', '📜', 'United States'),
('AP English', 'Literature and Language AP courses', '📖', 'United States');

-- United Kingdom subjects
INSERT INTO subjects (name, description, icon, country) VALUES
('GCSE Mathematics', 'General Certificate of Secondary Education Math', '📊', 'United Kingdom'),
('GCSE English', 'GCSE English Language and Literature', '📖', 'United Kingdom'),
('GCSE Sciences', 'Biology, Chemistry, and Physics GCSE', '🔬', 'United Kingdom'),
('A-Level Mathematics', 'Advanced Level Mathematics', '📐', 'United Kingdom'),
('A-Level Computer Science', 'Advanced Level Computing', '💻', 'United Kingdom'),
('A-Level Physics', 'Advanced Level Physics', '⚛️', 'United Kingdom'),
('A-Level Chemistry', 'Advanced Level Chemistry', '🧪', 'United Kingdom'),
('A-Level Biology', 'Advanced Level Biology', '🧬', 'United Kingdom');

-- India subjects
INSERT INTO subjects (name, description, icon, country) VALUES
('JEE Preparation', 'Joint Entrance Examination for engineering', '⚙️', 'India'),
('NEET Preparation', 'National Eligibility Entrance Test for medical', '🏥', 'India'),
('CBSE Mathematics', 'Central Board mathematics curriculum', '📊', 'India'),
('CBSE Physics', 'Central Board physics curriculum', '⚛️', 'India'),
('CBSE Chemistry', 'Central Board chemistry curriculum', '🧪', 'India'),
('CBSE Biology', 'Central Board biology curriculum', '🧬', 'India'),
('ICSE English', 'Indian Certificate of Secondary Education English', '📖', 'India'),
('ISC Computer Science', 'Indian School Certificate computing', '💻', 'India');

-- Australia subjects
INSERT INTO subjects (name, description, icon, country) VALUES
('HSC Mathematics', 'Higher School Certificate Mathematics', '📊', 'Australia'),
('HSC English', 'Higher School Certificate English', '📖', 'Australia'),
('HSC Sciences', 'Biology, Chemistry, and Physics HSC', '🔬', 'Australia'),
('VCE Mathematics', 'Victorian Certificate of Education Math', '📐', 'Australia'),
('ATAR Preparation', 'Australian Tertiary Admission Rank prep', '🎯', 'Australia'),
('HSC Modern History', 'Higher School Certificate History', '📜', 'Australia'),
('HSC Geography', 'Higher School Certificate Geography', '🌍', 'Australia'),
('HSC Economics', 'Higher School Certificate Economics', '💰', 'Australia');

-- Canada subjects
INSERT INTO subjects (name, description, icon, country) VALUES
('Grade 12 Mathematics', 'Advanced Functions and Calculus', '📊', 'Canada'),
('Grade 12 English', 'University-level English courses', '📖', 'Canada'),
('Grade 12 Sciences', 'Biology, Chemistry, and Physics Grade 12', '🔬', 'Canada'),
('Ontario Curriculum', 'Ontario secondary school curriculum', '🍁', 'Canada'),
('BC Curriculum', 'British Columbia graduation requirements', '🏔️', 'Canada'),
('French Immersion', 'French language and literature', '🇫🇷', 'Canada'),
('Canadian History', 'Grade 10-12 Canadian and World History', '📜', 'Canada'),
('Computer Studies', 'Programming and computer science', '💻', 'Canada');

-- Netherlands subjects
INSERT INTO subjects (name, description, icon, country) VALUES
('VWO Mathematics', 'Pre-university mathematics (VWO level)', '📊', 'Netherlands'),
('VWO Physics', 'Pre-university physics curriculum', '⚛️', 'Netherlands'),
('VWO Chemistry', 'Pre-university chemistry studies', '🧪', 'Netherlands'),
('VWO Biology', 'Pre-university biology curriculum', '🧬', 'Netherlands'),
('Dutch Language', 'Nederlandse taal en literatuur', '🇳🇱', 'Netherlands'),
('English Literature', 'English language and literature VWO', '📖', 'Netherlands'),
('History VWO', 'Dutch and European history', '📜', 'Netherlands'),
('Economics VWO', 'Economics and business studies', '💰', 'Netherlands');

-- Add user country preference to profiles
ALTER TABLE profiles ADD COLUMN country VARCHAR(50) DEFAULT 'Global';