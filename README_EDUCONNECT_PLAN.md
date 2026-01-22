EduConnect — Student-Only Web App (MVP) — Summary

This repository contains the web front-end and starter assets for EduConnect. Below are the key deliverables added to match the plan:

Added files (JS/SQL/Starter Snack):
- config/supabaseClient.js  -> helper to instantiate Supabase client (fill URL and anon key).
- config/topics_by_country.js -> country-specific subjects (Nigeria excluded).
- utils/coinUtils.js -> coin packs and pricing helpers (20=$7, 50=$17, 100=$33).
- scripts/007_supabase_schema.sql -> Supabase table definitions and basic seed data.
- buy-coins.html, payment.html -> updated pricing flow (already present/updated).
- snack/App.js and minimal screens/components -> JS-only Expo Snack starter (paste into Snack).

Supabase notes:
- Create a Supabase project, enable Auth (email + Google), create a storage bucket for `resources` and `avatars`.
- Apply `scripts/007_supabase_schema.sql` via SQL editor to create tables.
- Configure RLS policies to protect premium resources; allow public read for free resources.

Payments (MVP):
- Placeholders exist for Flutterwave and Google Pay; use client-side placeholders and test flows before integrating production SDKs and webhook verification.

Next recommended steps:
- Fill `config/supabaseClient.js` with real Supabase URL and anon key.
- Deploy a test Supabase project and run the SQL script.
- Paste `snack/*` files into an Expo Snack to iterate mobile UI.
- Tell me which next item you want implemented (e.g., full Snack screens, payment integration, RLS policies, or sample data). 
