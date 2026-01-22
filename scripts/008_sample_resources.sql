-- scripts/008_sample_resources.sql
-- Sample resources with coin costs for EduConnect.
-- Run after 007_supabase_schema.sql

INSERT INTO resources (title, description, subject, country, price_coins, public, created_by, created_at) VALUES
-- Free Resources (public)
('Chapter 1: Basics', 'Introduction to fundamentals', 'Mathematics', 'United States', 0, true, NULL, now()),
('Chapter 2: Advanced Concepts', 'Build on basics', 'Mathematics', 'United States', 0, true, NULL, now()),

-- Premium Resources
-- Chapter = 1 coin
('Chapter 3 - Premium Notes', 'Detailed notes for advanced topics', 'Mathematics', 'United States', 1, false, NULL, now()),
('Chapter 4 - Premium Notes', 'Detailed notes for calculus', 'Mathematics', 'United States', 1, false, NULL, now()),

-- Practice Packs = 2 coins
('Practice Set A (50 Questions)', 'Questions 1-50 with solutions', 'Mathematics', 'United States', 2, false, NULL, now()),
('Practice Set B (50 Questions)', 'Questions 51-100 with solutions', 'Mathematics', 'United States', 2, false, NULL, now()),
('Physics Lab Exercises', '10 hands-on lab problems', 'Physics', 'United Kingdom', 2, false, NULL, now()),

-- Exam Packs = 5 coins
('Mock Exam Paper 1', 'Full practice exam with answers', 'Mathematics', 'United States', 5, false, NULL, now()),
('IIT-JEE Practice Pack', 'Previous year questions (100)', 'IIT-JEE Prep', 'India', 5, false, NULL, now()),
('NEET Prep Bundle', 'Biology + Chemistry practice', 'NEET Prep', 'India', 5, false, NULL, now()),
('TOEFL Speaking Guide', 'Complete speaking section prep', 'English', 'United States', 5, false, NULL, now()),

-- Multiple Subjects
('Biology: Cell Structure & Function', 'Detailed diagrams and notes', 'Biology', 'Australia', 2, false, NULL, now()),
('Chemistry: Periodic Table Master Guide', 'Elements, trends, bonding', 'Chemistry', 'Canada', 3, false, NULL, now()),
('Computer Science: Data Structures', 'Arrays, Trees, Graphs with code', 'Computer Science', 'Singapore', 4, false, NULL, now());
