# EduConnect Setup Guide

## Backend Not Working? Follow These Steps:

### 1. Create a Supabase Account
1. Go to [https://supabase.com](https://supabase.com)
2. Sign up for a free account
3. Create a new project

### 2. Get Your Supabase Credentials
1. In your Supabase project dashboard, go to **Settings** → **API**
2. Copy these two values:
   - **Project URL** (looks like: `https://xxxxxxxxxxxxx.supabase.co`)
   - **anon/public key** (a long string starting with `eyJ...`)

### 3. Configure the Application

**Option A: Use config.js (Recommended)**
1. Open `config.js`
2. Replace the placeholder values:
   ```javascript
   const SUPABASE_URL = 'https://your-project.supabase.co'
   const SUPABASE_ANON_KEY = 'your-anon-key-here'
   ```
3. Add this line to ALL HTML files (after the Supabase CDN script):
   ```html
   <script src="config.js"></script>
   ```

**Option B: Update Each File Individually**
Replace the placeholders in these files:
- login.html
- signup.html
- dashboard.html
- subjects.html
- subject-detail.html
- rooms.html
- profile.html

Find and replace:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL'
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'
```

### 4. Set Up Database Tables

Run these SQL scripts in Supabase SQL Editor (in order):

**Script 1: Initial Schema** (`scripts/001_initial_schema.sql`)
- Creates profiles, subjects, resources, study_rooms tables
- Sets up relationships and triggers

**Script 2: Seed Data** (`scripts/002_seed_subjects.sql`)
- Adds initial subjects (Computer Science, Mathematics, etc.)

**Script 3: Helper Functions** (`scripts/003_add_increment_function.sql`)
- Adds download counter function

### 5. Configure Authentication

In Supabase Dashboard:
1. Go to **Authentication** → **Providers**
2. Enable **Email** provider
3. Configure email templates (optional)
4. For OTP: Go to **Authentication** → **Email Templates** → Enable "Confirm signup"

### 6. Set Up Row Level Security (RLS)

The SQL scripts include RLS policies, but verify:
1. Go to **Authentication** → **Policies**
2. Ensure policies are enabled for all tables
3. Users should be able to:
   - Read all public data
   - Insert/update their own data
   - Download resources they've paid for

### 7. Test the Application

1. Open `index.html` in a browser
2. Click "Sign Up"
3. Create an account (you'll receive an OTP email)
4. Enter OTP and verify
5. You should be redirected to the dashboard

## Troubleshooting

### "Invalid API key" error
- Double-check your SUPABASE_ANON_KEY is correct
- Make sure there are no extra spaces or quotes

### "Failed to fetch" error
- Verify SUPABASE_URL is correct
- Check if your Supabase project is active

### OTP not received
- Check spam folder
- Verify email provider is configured in Supabase
- Check Supabase logs: **Authentication** → **Logs**

### Database errors
- Ensure all SQL scripts ran successfully
- Check **Database** → **Tables** to verify tables exist
- Review **Database** → **Logs** for errors

### CORS errors
- Supabase handles CORS automatically
- If issues persist, check **Settings** → **API** → **CORS**

## Quick Start Checklist

- [ ] Created Supabase account
- [ ] Created new project
- [ ] Copied Project URL and anon key
- [ ] Updated config.js or individual files
- [ ] Ran all SQL scripts in order
- [ ] Enabled email authentication
- [ ] Tested signup flow
- [ ] Tested login flow
- [ ] Verified dashboard loads

## Need Help?

- Supabase Docs: https://supabase.com/docs
- Check browser console for errors (F12)
- Review Supabase logs in dashboard
