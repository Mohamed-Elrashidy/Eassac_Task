# Easacc Flutter Developer Task

**Author:** Mohamed Elrashidy  
**Platform:** iOS & Android  

## 🎥 Demo Video

Watch the application demo: [View Demo on Google Drive](https://drive.google.com/file/d/1NjTmHr5c3Xa4WFESdUT_-vzP09PfEpK2/view?usp=drivesdk)

## 📋 Project Overview

This is a Flutter application developed as part of the Easacc Flutter Developer interview task. The application demonstrates proficiency in Flutter development, social media authentication, network device scanning, and WebView integration.

## ✨ Features

The application consists of **3 main pages** as per requirements:

### 1. 🔐 Social Media Login Page
- **Facebook Authentication** - Login with Facebook account // all configurations and code added but not working properly due to need for business account
- **Google Authentication** - Login with Google account
- Secure authentication flow using Firebase Authentication
- Persistent login state (remembers logged-in user)
- Professional UI with animated buttons and loading states
- Error handling and user feedback

### 2. ⚙️ Settings Page
- **Web URL Configuration**
  - Input field to enter/modify the URL for WebView
  - Save URL to persistent storage
  - URL validation and formatting
  - Shows current saved URL
  
- **Network Devices Scanner**
  - **WiFi Networks:** Scans and lists nearby WiFi networks with:
    - Network name (SSID)
    - Signal strength (dBm)
    - Security type (WPA3, WPA2, WPA, WEP, Open)
    - Frequency (2.4GHz/5GHz band)
    - Current connected network indicator
  
  - **Bluetooth Devices:** Scans and lists nearby Bluetooth devices with:
    - Device name
    - Signal strength (RSSI)
    - Connection status
    - Suitable for printer discovery
  
  - Dropdown list to view all discovered devices
  - Refresh button to rescan devices
  - Permission handling for location and Bluetooth access

- **User Account Management**
  - Display current logged-in user information
  - Logout functionality
  - Profile picture (if available from social login)

### 3. 🌐 WebView Page
- Displays the website URL configured in Settings page
- Full-featured web browser with:
  - Navigation controls (back, forward, reload)
  - Progress indicator during page loading
  - JavaScript support
  - Handles navigation errors
  - Responsive and smooth browsing experience
