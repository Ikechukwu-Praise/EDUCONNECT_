-- Create a function to increment resource download counts
CREATE OR REPLACE FUNCTION increment(row_id UUID, x INTEGER)
RETURNS VOID AS $$
BEGIN
  UPDATE resources
  SET downloads = downloads + x
  WHERE id = row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
