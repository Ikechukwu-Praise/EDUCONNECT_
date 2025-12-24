// snack/lib/supabase.js
import { createClient } from '@supabase/supabase-js';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from '../../config/supabaseClient.js';

// Ensure you fill `config/supabaseClient.js` with your project values before using.
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
