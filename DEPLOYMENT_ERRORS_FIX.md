# CRITICAL DEPLOYMENT ERRORS - RESOLUTION GUIDE

## Issues Found

### 1. **Database Schema Missing Columns** ⚠️ CRITICAL
**Problem:** The `profiles` table is missing the `university` and `email` columns that the signup form tries to insert.

**Current Schema (database_setup.sql):**
```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  full_name TEXT,
  coins INTEGER DEFAULT 100,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Missing:** `university`, `email`, `country`, `class_level`

**Impact:** Profile creation fails when user signs up, causing "database error adding new user"

### 2. **No Auto-Profile Creation Trigger** ⚠️ CRITICAL
**Problem:** The database doesn't have a trigger to automatically create a profile when a new user is created in auth.users. The signup form tries to manually insert, which fails due to RLS or schema issues.

**Solution:** The `FIX_DEPLOYMENT_ERRORS.sql` file includes a proper trigger that:
- Automatically creates profiles when users sign up
- Extracts profile data from user metadata
- Handles conflicts properly

### 3. **RLS Policy Permissions** 
**Problem:** The INSERT policy on profiles requires `auth.uid() = id`, but if the trigger function doesn't run with elevated permissions, it fails.

**Fix:** Ensure the trigger function runs with `SECURITY DEFINER` to bypass RLS.

### 4. **Error Handling in Signup** ⚠️ MEDIUM
**Problem:** If profile creation fails, the entire signup fails, leaving the user created but with no profile.

**Fix:** Updated signup.html to:
- Catch profile creation errors separately
- Allow signup to complete even if profile creation fails (trigger will handle it)
- Log errors for debugging

## Deployment Steps

### IMMEDIATE ACTION REQUIRED:

1. **Run FIX_DEPLOYMENT_ERRORS.sql in Supabase SQL Editor:**
   - Go to: https://app.supabase.com → Select your project → SQL Editor
   - Copy entire content of `FIX_DEPLOYMENT_ERRORS.sql`
   - Click "Run" button
   - Wait for success message

2. **Test the fix:**
   - Go to signup.html
   - Try creating a new account with:
     - Full Name: Test User
     - Email: testuser@university.edu
     - University: Test University
     - Country: United States
     - Class Level: Undergraduate - Year 1
     - Password: TestPassword123
   - Check browser console for any errors
   - Verify email confirmation link works
   - Verify profile appears in Supabase dashboard

3. **If still failing, check:**
   - Supabase project is active and connected
   - API key in HTML files is correct
   - Anon key has proper permissions
   - Check Supabase logs for actual error messages

## Files Modified

1. `FIX_DEPLOYMENT_ERRORS.sql` - NEW (Complete database fix)
2. `signup.html` - Updated error handling

## What the Fix Does

✅ Adds missing columns to profiles table
✅ Creates database trigger to auto-create profiles
✅ Sets proper RLS permissions
✅ Handles profile creation with all required fields
✅ Implements conflict resolution (upsert)
✅ Grants necessary permissions to service role

## Testing Checklist

- [ ] Run FIX_DEPLOYMENT_ERRORS.sql
- [ ] Create new test account
- [ ] Receive verification email
- [ ] Verify email link works
- [ ] Login with new account
- [ ] See profile data loaded correctly
- [ ] Check dashboard shows correct user info
- [ ] Check coins balance displays (should be 10)

## Still Having Issues?

**Check Supabase Logs:**
1. Go to Supabase Dashboard → Your Project
2. Click "Database" → SQL Editor
3. Run: `SELECT * FROM public.profiles LIMIT 5;`
4. Should see your test user profile

**Debug Network Errors:**
1. Open Browser DevTools (F12)
2. Go to Console tab
3. Try signup again
4. Look for exact error message

**Common Errors:**

| Error | Solution |
|-------|----------|
| "relation 'profiles' does not exist" | Run FIX_DEPLOYMENT_ERRORS.sql |
| "violates row level security policy" | Ensure trigger has SECURITY DEFINER |
| "column does not exist" | Check columns were added (university, email) |
| "permission denied" | Grant permissions in FIX_DEPLOYMENT_ERRORS.sql |

## Important Notes

⚠️ **DO NOT skip running FIX_DEPLOYMENT_ERRORS.sql**

This is a one-time setup that must be done before any new users can sign up. Once run, all future signups should work automatically.

The database trigger will handle all profile creation automatically. The signup form will still try to insert profile data, but if it fails, the trigger will have already created the profile correctly.

## Verification Query

After running the fix, test with this SQL query in Supabase:

```sql
-- Check profiles table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;

-- Check if trigger exists
SELECT trigger_name, event_manipulation, event_object_table 
FROM information_schema.triggers 
WHERE trigger_schema = 'public' AND event_object_table = 'users';
```

Should show:
- ✅ profiles table with: id, full_name, university, email, country, class_level, coins, created_at, updated_at
- ✅ Trigger: on_auth_user_created
