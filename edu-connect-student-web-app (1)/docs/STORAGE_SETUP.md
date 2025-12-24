// docs/STORAGE_SETUP.md
# Supabase Storage Setup for EduConnect

## Overview
EduConnect uses Supabase Storage to store:
- **Resource files** (PDFs, study materials)
- **Profile avatars** (user photos)

---

## 1. Create Storage Buckets

### Via Supabase Dashboard
1. Go to **Storage** in Supabase Dashboard
2. Click **Create a new bucket**
3. Create two public buckets:

#### Bucket 1: `resources`
- **Name**: `resources`
- **Public**: Yes (allow public read access for free resources)
- **Policy**: See RLS policies section below

#### Bucket 2: `avatars`
- **Name**: `avatars`
- **Public**: Yes (allow public read for profile pictures)

---

## 2. Storage Paths

### Resources Bucket Structure
```
resources/
  ├── {user-id}/
  │   ├── chapter_1_notes.pdf
  │   ├── practice_set.pdf
  │   └── exam_paper.pdf
  └── public/  (free resources)
      └── basics.pdf
```

### Avatars Bucket Structure
```
avatars/
  ├── {user-id}/
  │   └── profile.jpg
```

---

## 3. Upload Files (JavaScript)

### Upload a Resource File
```javascript
import { supabase } from './lib/supabase';

async function uploadResource(file, userId, resourceName) {
  const path = `${userId}/${resourceName}`;
  const { data, error } = await supabase.storage
    .from('resources')
    .upload(path, file);
  
  if (error) {
    console.error('Upload failed:', error.message);
    return null;
  }
  
  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from('resources')
    .getPublicUrl(path);
  
  return publicUrl;
}
```

### Upload Avatar
```javascript
async function uploadAvatar(file, userId) {
  const path = `${userId}/profile.jpg`;
  const { error } = await supabase.storage
    .from('avatars')
    .upload(path, file, { upsert: true });
  
  if (error) throw error;
  
  const { data: { publicUrl } } = supabase.storage
    .from('avatars')
    .getPublicUrl(path);
  
  return publicUrl;
}
```

---

## 4. Download Files

### Download a Resource
```javascript
async function downloadResource(resourcePath) {
  const { data, error } = await supabase.storage
    .from('resources')
    .download(resourcePath);
  
  if (error) throw error;
  
  // Create blob URL for download
  const url = URL.createObjectURL(data);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'resource.pdf';
  a.click();
}
```

---

## 5. RLS Policies for Storage

Apply these policies in Supabase SQL Editor for fine-grained access:

### Resources Bucket (Allow public read, authenticated write own files)
```sql
-- Public resources readable by all
CREATE POLICY "Public resources readable" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'resources'
    AND (auth.role() = 'authenticated' OR auth.role() = 'anon')
  );

-- Users can upload to their own folder
CREATE POLICY "Users upload own resources" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'resources'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can delete own resources
CREATE POLICY "Users delete own resources" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'resources'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );
```

### Avatars Bucket (Allow public read, authenticated write own)
```sql
-- Public avatars readable
CREATE POLICY "Public avatars readable" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'avatars'
    AND (auth.role() = 'authenticated' OR auth.role() = 'anon')
  );

-- Users can upload/update own avatar
CREATE POLICY "Users upload own avatar" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users update own avatar" ON storage.objects
  FOR UPDATE WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );
```

---

## 6. Integration with Resources Table

Link storage files to `resources` table:

```javascript
// When creating a resource
const { data: newResource, error } = await supabase
  .from('resources')
  .insert({
    title: 'Practice Exam',
    subject: 'Mathematics',
    country: 'United States',
    price_coins: 5,
    file_url: uploadedFilePublicUrl, // From uploadResource()
    public: false,
    created_by: userId
  });
```

---

## 7. Cleanup & Quotas

### Storage Limits
- Supabase free tier: 1 GB storage
- Supabase Pro: Higher limits

### Delete Old Files
```javascript
async function deleteResource(filePath) {
  const { error } = await supabase.storage
    .from('resources')
    .remove([filePath]);
  
  if (error) throw error;
}
```

---

## 8. Production Checklist
- [ ] Enable CORS if accessing from web domain
- [ ] Set appropriate RLS policies
- [ ] Configure file size limits (e.g., 50 MB)
- [ ] Monitor storage usage
- [ ] Set up backup/archival strategy for old files
- [ ] Enable CDN for faster downloads (Pro tier)
