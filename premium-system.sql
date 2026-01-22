-- Premium Study Packs System Schema
-- Run this in your Supabase SQL Editor

-- Study Packs Table
CREATE TABLE study_packs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  subject_id UUID REFERENCES subjects(id),
  pack_type VARCHAR(50) NOT NULL, -- 'chapter', 'practice', 'exam'
  coin_price INTEGER NOT NULL,
  country VARCHAR(100) NOT NULL,
  content_url TEXT,
  preview_content TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Purchases Table
CREATE TABLE user_purchases (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  study_pack_id UUID REFERENCES study_packs(id) ON DELETE CASCADE,
  coins_spent INTEGER NOT NULL,
  purchased_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, study_pack_id)
);

-- Coin Transactions Table
CREATE TABLE coin_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL, -- positive for purchases, negative for spending
  transaction_type VARCHAR(50) NOT NULL, -- 'purchase', 'spend', 'bonus'
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample study packs for different countries
INSERT INTO study_packs (title, description, subject_id, pack_type, coin_price, country, preview_content) VALUES
-- United States
('Algebra Fundamentals', 'Complete algebra chapter with examples and exercises', (SELECT id FROM subjects WHERE name = 'Mathematics' LIMIT 1), 'chapter', 1, 'United States', 'Learn basic algebraic operations...'),
('SAT Math Practice', 'Practice questions for SAT mathematics section', (SELECT id FROM subjects WHERE name = 'Mathematics' LIMIT 1), 'practice', 2, 'United States', '50 practice questions with solutions...'),
('AP Calculus Exam Pack', 'Complete exam preparation for AP Calculus', (SELECT id FROM subjects WHERE name = 'Mathematics' LIMIT 1), 'exam', 5, 'United States', 'Full exam simulation with timing...'),

-- United Kingdom
('GCSE Physics Chapter 1', 'Forces and Motion fundamentals', (SELECT id FROM subjects WHERE name = 'Physics' LIMIT 1), 'chapter', 1, 'United Kingdom', 'Understanding Newton laws...'),
('A-Level Chemistry Practice', 'Organic chemistry practice questions', (SELECT id FROM subjects WHERE name = 'Chemistry' LIMIT 1), 'practice', 2, 'United Kingdom', '40 challenging problems...'),
('GCSE English Exam Pack', 'Complete GCSE English preparation', (SELECT id FROM subjects WHERE name = 'English' LIMIT 1), 'exam', 5, 'United Kingdom', 'Essay writing and comprehension...'),

-- India
('CBSE Class 12 Physics', 'Electromagnetic Induction chapter', (SELECT id FROM subjects WHERE name = 'Physics' LIMIT 1), 'chapter', 1, 'India', 'Faraday law and applications...'),
('JEE Main Math Practice', 'Coordinate geometry practice set', (SELECT id FROM subjects WHERE name = 'Mathematics' LIMIT 1), 'practice', 2, 'India', '60 JEE level questions...'),
('NEET Biology Exam Pack', 'Complete NEET biology preparation', (SELECT id FROM subjects WHERE name = 'Biology' LIMIT 1), 'exam', 5, 'India', 'All topics with mock tests...');

-- Enable RLS
ALTER TABLE study_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE coin_transactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Study packs are viewable by everyone" ON study_packs FOR SELECT USING (true);
CREATE POLICY "Users can view their own purchases" ON user_purchases FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own purchases" ON user_purchases FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view their own transactions" ON coin_transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own transactions" ON coin_transactions FOR INSERT WITH CHECK (auth.uid() = user_id);