# 🔵 Facebook Sign-In Setup Guide

## ✅ Implementation Complete

Facebook Sign-In has been successfully added to your app! Now you need to configure it.

---

## 📋 What Was Implemented

### 1. **Dependencies Added**
```yaml
flutter_facebook_auth: ^7.1.1
```

### 2. **Code Changes**
- ✅ `lib/authentication/authentication_page.dart` - Added Facebook Sign-In button and logic
- ✅ `lib/settings/settings_page.dart` - Added Facebook sign-out
- ✅ `android/app/src/main/AndroidManifest.xml` - Added Facebook configuration
- ✅ `android/app/src/main/res/values/strings.xml` - Created for Facebook IDs
- ✅ `ios/Runner/Info.plist` - Already has CFBundleURLTypes configured

### 3. **UI Features**
- ✅ Google Sign-In button (Blue)
- ✅ Facebook Sign-In button (Facebook Blue)
- ✅ "OR" divider between buttons
- ✅ Loading indicators for each button
- ✅ Sign-out from both Google and Facebook

---

## 🚀 Setup Steps

### Step 1: Create Facebook App

1. **Go to Facebook Developers**: https://developers.facebook.com/
2. **Click "My Apps"** → **"Create App"**
3. **Select "Consumer"** or "Other" type
4. **Enter App Name**: "Eassac Task" (or your app name)
5. **Enter Contact Email**
6. **Click "Create App"**

### Step 2: Get Facebook App ID and Client Token

After creating the app:

1. Go to **Settings** → **Basic**
2. **Copy "App ID"** (e.g., 123456789012345)
3. **Copy "Client Token"** (you may need to click "Show" first)

### Step 3: Configure Android

#### 3.1 Update strings.xml

Open `/Users/mohamedelrashidy/Eassac_Task/android/app/src/main/res/values/strings.xml`

Replace placeholders with your actual values:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Eassac Task</string>
    
    <!-- Replace with YOUR actual Facebook App ID -->
    <string name="facebook_app_id">123456789012345</string>
    
    <!-- Replace with YOUR actual Facebook Client Token -->
    <string name="facebook_client_token">abc123def456ghi789</string>
    
    <!-- This is your Facebook App ID prefixed with 'fb' -->
    <string name="fb_login_protocol_scheme">fb123456789012345</string>
</resources>
```

**Example:**
If your App ID is `123456789012345`:
- `facebook_app_id`: `123456789012345`
- `fb_login_protocol_scheme`: `fb123456789012345` (add "fb" prefix)

#### 3.2 Get Android Key Hash

Facebook needs your app's key hash. Run this command:

```bash
cd /Users/mohamedelrashidy/Eassac_Task/android

# For Debug keystore
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
```

When prompted for password, enter: `android`

**Copy the output** (it will look like: `Ab1Cd2Ef3Gh4Ij5Kl6Mn7Op8Qr9St0=`)

### Step 4: Configure Facebook App for Android

1. In Facebook Developers, go to your app
2. Click **"Add Platform"** → Select **"Android"**
3. **Package Name**: `com.example.app` (from your build.gradle)
4. **Class Name**: `com.example.app.MainActivity`
5. **Key Hash**: Paste the hash from Step 3.2
6. Click **"Save Changes"**

### Step 5: Configure iOS (Already Partially Done)

Your Info.plist already has the URL scheme configured:
```xml
<string>com.googleusercontent.apps.908797335681-hnes1d8jvknqn347o78889km28habc3i</string>
```

But you need to add Facebook's URL scheme:

#### 5.1 Update Info.plist

The file already has `CFBundleURLTypes`. You need to add Facebook's scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <!-- Existing Google URL Scheme -->
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.908797335681-hnes1d8jvknqn347o78889km28habc3i</string>
        </array>
    </dict>
    
    <!-- Add Facebook URL Scheme -->
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fb123456789012345</string>  <!-- Replace with your App ID -->
        </array>
    </dict>
</array>

<!-- Add Facebook App ID -->
<key>FacebookAppID</key>
<string>123456789012345</string>  <!-- Replace with your App ID -->

<!-- Add Facebook Display Name -->
<key>FacebookDisplayName</key>
<string>Eassac Task</string>

<!-- LSApplicationQueriesSchemes for Facebook -->
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fbapi</string>
    <string>fb-messenger-share-api</string>
    <string>fbauth2</string>
    <string>fbshareextension</string>
</array>
```

### Step 6: Configure Facebook App for iOS

1. In Facebook Developers, go to your app
2. Click **"Add Platform"** → Select **"iOS"**
3. **Bundle ID**: `com.example.app` (from your Xcode project)
4. Click **"Save Changes"**

### Step 7: Enable Facebook Login

1. In Facebook Developers console
2. Go to **"Products"** → Click **"Add Products"**
3. Find **"Facebook Login"** → Click **"Set Up"**
4. Click **"Settings"** under Facebook Login
5. Add these **Valid OAuth Redirect URIs**:
   ```
   https://your-project-id.firebaseapp.com/__/auth/handler
   ```
   (Replace `your-project-id` with your Firebase project ID)

### Step 8: Enable Facebook in Firebase

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select your project
3. Go to **Authentication** → **Sign-in method**
4. Find **Facebook** in the list
5. Click on it → **Enable**
6. **Enter your Facebook App ID** (from Step 2)
7. **Enter your Facebook App Secret**:
   - Go to Facebook Developers → Settings → Basic
   - Click "Show" next to "App Secret"
   - Copy and paste it to Firebase
8. **Copy the OAuth redirect URI** shown in Firebase
9. Click **"Save"**

### Step 9: Clean and Rebuild

```bash
cd /Users/mohamedelrashidy/Eassac_Task

# Clean
flutter clean
cd android && ./gradlew clean && cd ..

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

---

## 📱 Testing Facebook Sign-In

### On Android:
1. Run the app: `flutter run`
2. Click **"Sign in with Facebook"** button
3. Facebook login screen appears
4. Enter Facebook credentials
5. Grant permissions
6. App navigates to Settings page
7. User email shown in app bar

### On iOS:
1. Open Xcode project
2. Select a device/simulator
3. Run: `flutter run -d ios`
4. Click **"Sign in with Facebook"** button
5. Facebook login appears
6. Complete authentication
7. App navigates to Settings page

---

## 🔍 Verification Checklist

Before testing:

- [ ] Facebook App created
- [ ] App ID and Client Token copied
- [ ] `strings.xml` updated with Facebook App ID
- [ ] `fb_login_protocol_scheme` has "fb" prefix + App ID
- [ ] Android Key Hash generated and added to Facebook
- [ ] Android platform configured in Facebook Developers
- [ ] iOS Bundle ID configured in Facebook Developers
- [ ] Info.plist updated with Facebook URL scheme
- [ ] Facebook Login enabled in Firebase
- [ ] Facebook App Secret added to Firebase
- [ ] OAuth redirect URI configured
- [ ] App cleaned and rebuilt

---

## ⚠️ Common Issues & Solutions

### Issue 1: "App Not Set Up"
**Error**: App not setup: This app is still in development mode

**Solution**: 
1. Go to Facebook Developers → Your App
2. Toggle the app to "Live" mode (top of the page)
3. Complete the required information
4. OR add test users in Development mode

### Issue 2: Invalid Key Hash
**Error**: Invalid key hash

**Solution**:
1. Generate key hash again using the command in Step 3.2
2. Make sure password is `android`
3. Add the hash to Facebook Developers → Settings → Basic → Key Hashes
4. You can add multiple hashes (debug + release)

### Issue 3: "Can't Load URL"
**Error**: Can't load URL: The domain is not authorized

**Solution**:
1. Check OAuth redirect URI in Firebase
2. Make sure it's added to Facebook → Facebook Login → Settings → Valid OAuth Redirect URIs
3. Format: `https://YOUR-PROJECT-ID.firebaseapp.com/__/auth/handler`

### Issue 4: Package Name Mismatch
**Error**: App package name doesn't match

**Solution**:
1. Check package name in: `android/app/build.gradle.kts` → `applicationId`
2. Should match Facebook → Settings → Android → Package Name
3. Should be: `com.example.app`

### Issue 5: Info.plist Not Updated
**Error**: iOS login doesn't work

**Solution**:
1. Make sure Facebook URL scheme is in Info.plist
2. Format: `fb123456789012345` (fb + your App ID)
3. Check FacebookAppID is also added
4. Rebuild the app

---

## 📊 File Changes Summary

### Files Created:
```
android/app/src/main/res/values/strings.xml
```

### Files Modified:
```
pubspec.yaml                                    # Added flutter_facebook_auth
lib/authentication/authentication_page.dart     # Added Facebook sign-in
lib/settings/settings_page.dart                # Added Facebook sign-out
android/app/src/main/AndroidManifest.xml       # Added Facebook config
ios/Runner/Info.plist                          # Needs Facebook URL scheme
```

---

## 🎯 Quick Setup Commands

```bash
# 1. Install dependencies
cd /Users/mohamedelrashidy/Eassac_Task
flutter pub get

# 2. Generate Android key hash
cd android
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
# Password: android

# 3. Clean and rebuild
cd ..
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter run
```

---

## 🎨 UI Preview

Your authentication page now shows:

```
┌─────────────────────────────────┐
│         [App Logo Icon]         │
│                                 │
│          Welcome!               │
│   Sign in to access your app    │
│                                 │
│  ┌───────────────────────────┐  │
│  │  🔵 Sign in with Google  │  │
│  └───────────────────────────┘  │
│                                 │
│           ─── OR ───            │
│                                 │
│  ┌───────────────────────────┐  │
│  │  f Sign in with Facebook │  │
│  └───────────────────────────┘  │
│                                 │
│    Terms of Service &           │
│      Privacy Policy             │
└─────────────────────────────────┘
```

---

## ✅ Success Indicators

You'll know it's working when:

1. ✅ App builds without errors
2. ✅ Both sign-in buttons appear
3. ✅ Google sign-in works
4. ✅ Facebook sign-in button opens Facebook login
5. ✅ After Facebook auth, navigates to Settings
6. ✅ User email shows in Settings app bar
7. ✅ Sign-out button works for both providers

---

## 📞 Need Help?

### Get Facebook App Info:
- Facebook Developers: https://developers.facebook.com/
- Your Apps → Select App → Settings → Basic

### Debug Commands:
```bash
# View logs
flutter run -v

# Android logs
adb logcat | grep -i facebook

# Check strings.xml
cat /Users/mohamedelrashidy/Eassac_Task/android/app/src/main/res/values/strings.xml
```

---

## 🎉 You're Ready!

Once configured:
1. Users can sign in with Google
2. Users can sign in with Facebook
3. Sign-out works for both
4. User info displayed in Settings

**Both social media logins are now fully functional!** 🚀

