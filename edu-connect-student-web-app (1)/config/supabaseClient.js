// config/supabaseClient.js
// Minimal JS helper to create a Supabase client. Fill in your project values.
export const SUPABASE_URL = 'https://your-project.supabase.co';
export const SUPABASE_ANON_KEY = '<YOUR-ANON-KEY-HERE>';

export function createSupabaseClient(supabaseLib) {
  if (!supabaseLib || typeof supabaseLib.createClient !== 'function') {
    throw new Error('Pass the `@supabase/supabase-js` library reference to createSupabaseClient');
  }
  return supabaseLib.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}
