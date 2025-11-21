# 🔵 Quick Facebook Configuration Guide

## 📝 Files That Need Your Facebook App Credentials

You have these files ready and waiting for your Facebook App credentials:

### 1. Android: `strings.xml`
**Location**: `/Users/mohamedelrashidy/Eassac_Task/android/app/src/main/res/values/strings.xml`

**Current placeholders:**
```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
<string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
```

**Example with real values:**
```xml
<string name="facebook_app_id">1234567890123456</string>
<string name="facebook_client_token">abc123def456ghi789jkl012mno345</string>
<string name="fb_login_protocol_scheme">fb1234567890123456</string>
```

### 2. iOS: `Info.plist`
**Location**: `/Users/mohamedelrashidy/Eassac_Task/ios/Runner/Info.plist`

**Current placeholders (2 places):**
```xml
<!-- In CFBundleURLSchemes array -->
<string>fbYOUR_FACEBOOK_APP_ID</string>

<!-- Under FacebookAppID key -->
<string>YOUR_FACEBOOK_APP_ID</string>
```

**Example with real values:**
```xml
<!-- In CFBundleURLSchemes array -->
<string>fb1234567890123456</string>

<!-- Under FacebookAppID key -->
<string>1234567890123456</string>
```

---

## 🚀 Step-by-Step: Getting Your Facebook Credentials

### Step 1: Create Facebook App (5 minutes)

1. **Go to**: https://developers.facebook.com/apps/
2. **Click**: "Create App"
3. **Select**: "Consumer" (or "Other" if asked)
4. **App Name**: "Eassac Task"
5. **Contact Email**: your-email@example.com
6. **Click**: "Create App"

### Step 2: Get Your Credentials

Once app is created:

1. **Go to**: Dashboard → Settings → Basic
2. **Find "App ID"**: Copy it (e.g., `1234567890123456`)
3. **Find "App Secret"**: Click "Show", copy it
4. **Find "Client Token"**: Scroll down, copy it

---

## ✏️ What to Replace (Summary)

### For Android (`strings.xml`):
Replace these **3 values**:
1. `YOUR_FACEBOOK_APP_ID` → Your App ID (e.g., `1234567890123456`)
2. `YOUR_FACEBOOK_CLIENT_TOKEN` → Your Client Token
3. `fbYOUR_FACEBOOK_APP_ID` → `fb` + Your App ID (e.g., `fb1234567890123456`)

### For iOS (`Info.plist`):
Replace these **2 values** (in 2 places):
1. Line ~40: `fbYOUR_FACEBOOK_APP_ID` → `fb` + Your App ID
2. Line ~48: `YOUR_FACEBOOK_APP_ID` → Your App ID

---

## 🔧 Quick Commands After Updating

```bash
# 1. Navigate to project
cd /Users/mohamedelrashidy/Eassac_Task

# 2. Clean build
flutter clean

# 3. Get dependencies
flutter pub get

# 4. Rebuild and run
flutter run
```

---

## 📱 Configure Platforms in Facebook

### For Android:

1. In Facebook app → Settings → Basic
2. Click **"+ Add Platform"** → Select **"Android"**
3. **Package Name**: `com.example.app`
4. **Class Name**: `com.example.app.MainActivity`
5. **Key Hash**: Get from command:
   ```bash
   cd /Users/mohamedelrashidy/Eassac_Task/android
   keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
   ```
   Password: `android`
6. **Save Changes**

### For iOS:

1. In Facebook app → Settings → Basic
2. Click **"+ Add Platform"** → Select **"iOS"**
3. **Bundle ID**: `com.example.app`
4. **Save Changes**

---

## 🔥 Enable Facebook Login Product

1. In Facebook Developer Console → Your App
2. Click **"Add Product"**
3. Find **"Facebook Login"** → Click **"Set Up"**
4. Select **Settings** under Facebook Login
5. **Valid OAuth Redirect URIs**: Add this:
   ```
   https://eassac-task.firebaseapp.com/__/auth/handler
   ```
   (Replace `eassac-task` with your Firebase project ID)
6. **Save Changes**

---

## 🔥 Enable in Firebase

1. **Firebase Console**: https://console.firebase.google.com/
2. Select your project
3. **Authentication** → **Sign-in method**
4. Find **Facebook** → Click it
5. **Toggle Enable**
6. **App ID**: Paste your Facebook App ID
7. **App Secret**: Paste your Facebook App Secret (from Step 2)
8. **Copy OAuth redirect URI** from Firebase
9. Paste it in Facebook → Facebook Login → Settings
10. **Save**

---

## ✅ Verification Checklist

Before running:
- [ ] Facebook App created
- [ ] App ID obtained
- [ ] Client Token obtained
- [ ] `strings.xml` updated (3 values)
- [ ] `Info.plist` updated (2 values)
- [ ] Android platform added in Facebook
- [ ] iOS platform added in Facebook
- [ ] Key Hash added for Android
- [ ] Facebook Login product enabled
- [ ] OAuth redirect URI configured
- [ ] Facebook enabled in Firebase
- [ ] App cleaned and rebuilt

---

## 🎯 Testing

After configuration:

```bash
flutter run
```

**Expected behavior:**
1. ✅ App launches with login page
2. ✅ Google Sign-In button visible
3. ✅ Facebook Sign-In button visible
4. ✅ Click Facebook button → Facebook login opens
5. ✅ Enter credentials → App navigates to Settings
6. ✅ User email shown in app bar
7. ✅ Sign out works

---

## 🆘 Troubleshooting

### "App Not Setup"
- Make sure app is in Live mode in Facebook Developer Console
- OR add test users if in Development mode

### "Invalid Key Hash"
- Regenerate using the keytool command
- Make sure password is `android`
- Copy the exact output (including =)

### iOS Build Fails
- Clean Xcode build folder
- Delete Pods folder and Podfile.lock
- Run `pod install` in ios folder

---

## 📊 Current Status

### ✅ Code Implementation: COMPLETE
- All code written
- No errors
- Ready to use

### ⚙️ Configuration Files: READY AND WAITING
- `strings.xml` created with placeholders
- `Info.plist` updated with placeholders
- `AndroidManifest.xml` configured
- Just need your Facebook App credentials

### 🎯 Next Action: CREATE FACEBOOK APP
Estimated time: 15 minutes total

---

## 💡 Pro Tip

Save your Facebook credentials in a secure note:
```
Facebook App: Eassac Task
App ID: 1234567890123456
Client Token: abc123def456...
App Secret: xyz789abc123...
Created: 2025-11-21
```

This way you can easily reference them later!

---

## 🎉 Summary

**Your files are ready!** Just:
1. Create Facebook App (5 min)
2. Copy App ID & Client Token (1 min)
3. Update 2 files (2 min)
4. Configure platforms (5 min)
5. Enable in Firebase (2 min)
6. Test! (1 min)

**Total: ~15 minutes to fully working Facebook Sign-In!**

Good luck! 🚀

