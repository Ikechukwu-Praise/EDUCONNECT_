# FIX EMAIL CONFIRMATION - SUPABASE SETUP

## Problem
Email confirmation links are not being sent when users sign up.

## Root Cause
Supabase email provider is not configured. By default, Supabase has email disabled until you set it up.

---

## SOLUTION - Setup Supabase Email (3 Steps)

### STEP 1: Enable Email in Supabase Dashboard

1. **Go to:** https://app.supabase.com
2. **Select your EduConnect project**
3. **Left sidebar → Authentication**
4. **Click "Providers" tab**
5. **Look for "Email" section** - Should show "Disabled"
6. **Click the toggle to ENABLE it**

✅ Email provider should now be enabled

---

### STEP 2: Configure Email Settings

1. **In Authentication section, click "Email Templates"**
2. **You'll see:**
   - Confirmation email
   - Recovery email
   - Magic link email
   - Change email link

3. **For "Confirm signup" email:**
   - Click "Edit" (pencil icon)
   - The template should include `{{ .ConfirmationURL }}`
   - This is the verification link
   - Keep default template (it's fine)
   - Click "Save"

✅ Email templates are configured

---

### STEP 3: Verify Redirect URLs

1. **In Authentication, scroll down to "Site URL"**
   - Should be: `http://localhost:8000` (for testing)
   - Or your production domain
   
2. **Check "Redirect URLs"**
   - Should include: `http://localhost:8000/login.html`
   - Or your actual redirect URLs

✅ Redirect URLs are set correctly

---

## Optional: Add Custom SMTP (For Production)

If you want to use your own email service (Gmail, SendGrid, etc.):

### Using Gmail SMTP:
1. **Authentication → Email**
2. **Scroll to "SMTP Settings"**
3. **Enable Custom SMTP**
4. **Fill in:**
   - SMTP Host: `smtp.gmail.com`
   - SMTP Port: `587`
   - SMTP User: `your-email@gmail.com`
   - SMTP Password: `your-app-password` (NOT regular password!)
   - From Email: `your-email@gmail.com`

**To get Gmail App Password:**
- Go to: https://myaccount.google.com/security
- Enable 2-Factor Authentication
- Create "App Password" for Mail
- Use that password above

---

## TEST EMAIL CONFIGURATION

### Quick Test in Supabase:

1. **Go to Authentication → Users**
2. **Click "Invite user" button**
3. **Enter test email:**
   - Email: `test@example.com`
   - Role: authenticated
4. **Click "Invite"**
5. **Check your email** - You should receive an invitation link

✅ If you get the email, configuration is working!

---

## COMMON ISSUES & FIXES

### Issue: "Email still not being sent"

**Check 1: Email Provider is Enabled**
- Authentication → Providers → Email should be enabled (toggle ON)

**Check 2: SMTP is Configured** (if using custom)
- Check SMTP settings are filled correctly
- Test SMTP connection works

**Check 3: Email is Verified**
- If using Gmail SMTP, check App Password was created correctly
- If using SendGrid, check API key is valid

**Check 4: Check Supabase Logs**
- Authentication → Logs tab
- Look for email-related errors
- Copy error message for debugging

### Issue: "Email sent but link doesn't work"

**Check Redirect URL:**
1. Click the email confirmation link
2. Check the URL has `#access_token=` and `#type=`
3. If it's broken, check "Redirect URLs" in Authentication settings

**Fix:**
- Add to Redirect URLs: `http://localhost:8000/login.html`
- For production: add your actual domain

### Issue: "Users not being verified after clicking link"

**Check RLS Policies:**
1. Run the FIX_DEPLOYMENT_ERRORS.sql in SQL Editor
2. Policies need to allow email_confirmed updates

---

## YOUR CURRENT SETUP

Your signup.html already has:
```javascript
options: {
  data: { ... },
  emailRedirectTo: window.location.origin + '/login.html'
}
```

✅ This is correct - it will redirect to login.html after email verification

---

## TESTING FLOW

After setup, test this:

1. **Go to signup page**
2. **Sign up with new email:**
   - Name: Test User
   - Email: youremail@gmail.com
   - University: Test
   - Country: United States
   - Level: Undergraduate - Year 1
   - Password: Test123

3. **Should see:** "Account created! Check your email..."

4. **Go to email inbox** (Gmail/Outlook/etc)

5. **Look for email from:**
   - From: noreply@your-project-ref.supabase.co
   - Subject: "Confirm your email"
   - Contains a "Confirm Email" button or link

6. **Click the link** - Should redirect to login.html

7. **Login page should load** ✅

8. **If redirect works, copy the token from URL**

---

## EMAIL NOT SHOWING UP? 

### Check These (In Order):

1. **Spam/Junk folder**
   - Email might be caught by spam filter
   - Add `noreply@[your-project].supabase.co` to safe senders

2. **Check Console for Errors**
   - Press F12 in browser
   - Go to Console tab
   - Sign up again
   - Look for error messages

3. **Check Supabase Logs**
   - Dashboard → Your Project
   - Authentication → Logs
   - Look for "send_confirmation_email"
   - Check if there are errors

4. **Verify Email Provider**
   - Authentication → Providers → Email
   - Should show: "Enabled" with green checkmark

5. **Check SMTP Settings (if custom)**
   - Go to Authentication → Email
   - Click "SMTP Settings"
   - Verify all fields are filled correctly
   - Test connection button exists

---

## ALTERNATIVE: Skip Email Verification (Dev Only)

If you just want to test and skip email verification:

**NOT RECOMMENDED for production!** But for development:

1. **In Authentication settings**
2. **Look for "Require email confirmation"**
3. **Toggle it OFF**
4. **Now users auto-confirmed without email**

⚠️ Only for testing! Turn back ON for production!

---

## SUCCESS CHECKLIST

- [ ] Email provider is enabled in Supabase
- [ ] Email templates are configured
- [ ] Redirect URLs include login.html
- [ ] SMTP is configured (if custom)
- [ ] Test invitation email was received
- [ ] User can click link and be redirected
- [ ] User can login after email verification

---

## SUPPORT

If emails still aren't sending:

1. **Check Supabase Status:**
   - https://status.supabase.com
   - Make sure all systems are operational

2. **Try Different Email:**
   - Gmail, Outlook, Yahoo, etc.
   - Some emails have stricter spam filters

3. **Check Supabase Documentation:**
   - https://supabase.com/docs/guides/auth/auth-email

4. **Review Your Logs:**
   - Supabase Dashboard → Logs
   - Look for email send failures

---

**Status:** Ready to configure email in Supabase

**Estimated Time:** 5-10 minutes

**Difficulty:** Easy - Just toggle settings in dashboard
