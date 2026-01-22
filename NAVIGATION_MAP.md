# EduConnect Navigation Map

All pages are now properly connected. Here's the complete navigation structure:

## Public Pages (No Authentication Required)

### index.html (Landing Page)
- **Links to:**
  - login.html (Login button in nav + "Get Started Free" button)
  - signup.html (Sign Up button in nav)
  - #features (Learn More button - internal anchor)

### login.html
- **Links to:**
  - index.html (Logo/brand link)
  - signup.html ("Sign Up" link at bottom)
  - dashboard.html (redirects after successful login)

### signup.html
- **Links to:**
  - index.html (Logo/brand link)
  - login.html ("Sign In" link at bottom + redirects after signup)

## Protected Pages (Authentication Required)

All protected pages share the same navigation bar with:
- Logo → dashboard.html
- Dashboard → dashboard.html
- Subjects → subjects.html
- Study Rooms → rooms.html
- Profile → profile.html
- Logout button → index.html (after sign out)
- Coin balance display

### dashboard.html
- **Navigation bar** (as above)
- **Quick action cards:**
  - Browse Subjects → subjects.html
  - Study Rooms → rooms.html
  - Your Profile → profile.html

### subjects.html
- **Navigation bar** (as above)
- **Subject cards:** Each links to → subject-detail.html?id={subjectId}

### subject-detail.html
- **Navigation bar** (as above)
- **Back button** → subjects.html
- **Upload Resource button** (opens modal)
- **Download buttons** (for each resource)

### rooms.html
- **Navigation bar** (as above)
- **Create Room button** (opens modal)
- **Join/Leave buttons** (for each room)

### profile.html
- **Navigation bar** (as above)
- **Buy Coins button** (opens modal)

## Authentication Flow

1. **Unauthenticated users:**
   - index.html → login.html OR signup.html
   - signup.html → login.html → dashboard.html

2. **Authenticated users:**
   - All protected pages check authentication
   - If not authenticated → redirects to login.html
   - After login → dashboard.html

3. **Logout:**
   - Any protected page → logout button → index.html

## Page Connections Summary

```
index.html
├── login.html
│   └── dashboard.html (after login)
└── signup.html
    └── login.html (after signup)

dashboard.html (hub)
├── subjects.html
│   └── subject-detail.html?id=X
├── rooms.html
└── profile.html

All protected pages ↔ Navigation bar ↔ All other protected pages
All protected pages → Logout → index.html
```

## Key Features

✅ All navigation links are working
✅ Authentication redirects properly configured
✅ Consistent navigation bar across all protected pages
✅ Back navigation from subject-detail to subjects
✅ Logo always links to dashboard (when authenticated)
✅ Logout functionality on all protected pages
✅ Coin balance visible in all protected pages
