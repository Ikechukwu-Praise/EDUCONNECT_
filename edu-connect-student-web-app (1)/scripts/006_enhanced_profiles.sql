-- Enhanced profile fields
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS class_level VARCHAR(50);
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS profile_photo_url TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS date_of_birth DATE;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS phone_number VARCHAR(20);

-- User selected subjects table
CREATE TABLE IF NOT EXISTS user_subjects (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  subject_id INTEGER REFERENCES subjects(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, subject_id)
);

-- Class/Level options for different countries
CREATE TABLE IF NOT EXISTS class_levels (
  id SERIAL PRIMARY KEY,
  country VARCHAR(50) NOT NULL,
  level_name VARCHAR(100) NOT NULL,
  description TEXT,
  sort_order INTEGER DEFAULT 0
);

-- Insert class levels for target countries
INSERT INTO class_levels (country, level_name, description, sort_order) VALUES
-- United States
('United States', 'Grade 9 (Freshman)', 'High School Freshman Year', 9),
('United States', 'Grade 10 (Sophomore)', 'High School Sophomore Year', 10),
('United States', 'Grade 11 (Junior)', 'High School Junior Year', 11),
('United States', 'Grade 12 (Senior)', 'High School Senior Year', 12),
('United States', 'College Freshman', 'First Year University', 13),
('United States', 'College Sophomore', 'Second Year University', 14),
('United States', 'College Junior', 'Third Year University', 15),
('United States', 'College Senior', 'Fourth Year University', 16),

-- United Kingdom
('United Kingdom', 'Year 10', 'GCSE Preparation Year 1', 10),
('United Kingdom', 'Year 11', 'GCSE Examination Year', 11),
('United Kingdom', 'Year 12 (AS Level)', 'A-Level First Year', 12),
('United Kingdom', 'Year 13 (A2 Level)', 'A-Level Second Year', 13),
('United Kingdom', 'University Year 1', 'First Year University', 14),
('United Kingdom', 'University Year 2', 'Second Year University', 15),
('United Kingdom', 'University Year 3', 'Third Year University', 16),

-- India
('India', 'Class 9', 'Secondary School Class 9', 9),
('India', 'Class 10', 'Secondary School Class 10 (Board Exam)', 10),
('India', 'Class 11', 'Higher Secondary Class 11', 11),
('India', 'Class 12', 'Higher Secondary Class 12 (Board Exam)', 12),
('India', '1st Year College', 'First Year Undergraduate', 13),
('India', '2nd Year College', 'Second Year Undergraduate', 14),
('India', '3rd Year College', 'Third Year Undergraduate', 15),
('India', '4th Year College', 'Fourth Year Undergraduate', 16),

-- Australia
('Australia', 'Year 10', 'Secondary School Year 10', 10),
('Australia', 'Year 11', 'Senior Secondary Year 11', 11),
('Australia', 'Year 12', 'HSC/VCE Final Year', 12),
('Australia', 'University Year 1', 'First Year University', 13),
('Australia', 'University Year 2', 'Second Year University', 14),
('Australia', 'University Year 3', 'Third Year University', 15),

-- Canada
('Canada', 'Grade 9', 'Secondary School Grade 9', 9),
('Canada', 'Grade 10', 'Secondary School Grade 10', 10),
('Canada', 'Grade 11', 'Secondary School Grade 11', 11),
('Canada', 'Grade 12', 'Secondary School Grade 12', 12),
('Canada', 'University Year 1', 'First Year University', 13),
('Canada', 'University Year 2', 'Second Year University', 14),
('Canada', 'University Year 3', 'Third Year University', 15),
('Canada', 'University Year 4', 'Fourth Year University', 16),

-- Netherlands
('Netherlands', 'HAVO 4', 'Higher General Secondary Education Year 4', 10),
('Netherlands', 'HAVO 5', 'Higher General Secondary Education Year 5', 11),
('Netherlands', 'VWO 4', 'Pre-University Education Year 4', 10),
('Netherlands', 'VWO 5', 'Pre-University Education Year 5', 11),
('Netherlands', 'VWO 6', 'Pre-University Education Year 6', 12),
('Netherlands', 'University Year 1', 'First Year University', 13),
('Netherlands', 'University Year 2', 'Second Year University', 14),
('Netherlands', 'University Year 3', 'Third Year University', 15);