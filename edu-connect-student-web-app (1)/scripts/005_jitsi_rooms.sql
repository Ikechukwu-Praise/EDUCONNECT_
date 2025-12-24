-- Add Jitsi room ID and video call status to study_rooms table
ALTER TABLE study_rooms ADD COLUMN jitsi_room_id VARCHAR(255);
ALTER TABLE study_rooms ADD COLUMN video_active BOOLEAN DEFAULT FALSE;
ALTER TABLE study_rooms ADD COLUMN last_activity TIMESTAMP DEFAULT NOW();

-- Update existing rooms with Jitsi room IDs
UPDATE study_rooms SET jitsi_room_id = CONCAT('EduConnect-', id) WHERE jitsi_room_id IS NULL;

-- Add function to update room activity
CREATE OR REPLACE FUNCTION update_room_activity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE study_rooms 
  SET last_activity = NOW() 
  WHERE id = NEW.room_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for room activity updates
CREATE TRIGGER update_room_activity_trigger
  AFTER INSERT OR UPDATE ON study_room_participants
  FOR EACH ROW
  EXECUTE FUNCTION update_room_activity();