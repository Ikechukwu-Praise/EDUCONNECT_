-- Seed some sample subjects
INSERT INTO public.subjects (name, code, description, icon) VALUES
  ('Computer Science', 'CS101', 'Introduction to programming and algorithms', '💻'),
  ('Mathematics', 'MATH101', 'Calculus and linear algebra', '📐'),
  ('Physics', 'PHYS101', 'Classical mechanics and electromagnetism', '⚡'),
  ('Biology', 'BIO101', 'Cell biology and genetics', '🧬'),
  ('Chemistry', 'CHEM101', 'Organic and inorganic chemistry', '🧪'),
  ('English Literature', 'ENG101', 'Classic and modern literature analysis', '📚'),
  ('History', 'HIST101', 'World history and civilizations', '🌍'),
  ('Psychology', 'PSY101', 'Cognitive psychology and behavior', '🧠')
ON CONFLICT (code) DO NOTHING;
