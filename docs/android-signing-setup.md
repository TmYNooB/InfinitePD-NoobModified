# Android APK Signing Setup (Multi-PC)

This project supports release signing from either:
- environment variables (recommended for CI/shared scripts), or
- a local machine file: android/keystore.properties

If both are provided, environment variables win.

## 1) Create a keystore (once)

```powershell
keytool -genkeypair -v `
  -keystore C:\Users\$env:USERNAME\.keys\infinitepd-release.jks `
  -alias infinitepd `
  -keyalg RSA -keysize 2048 -validity 10000
```

## 2) Configure each development PC

Option A: Local file (easy for manual local builds)

1. Copy:
   - android/keystore.properties.example
   - to android/keystore.properties
2. Fill these keys:
   - storeFile
   - storePassword
   - keyAlias
   - keyPassword

Option B: Environment variables (good for CI / scripted setup)

Set these variables on each machine:
- INFIPD_KEYSTORE_PATH
- INFIPD_KEYSTORE_PASSWORD
- INFIPD_KEY_ALIAS
- INFIPD_KEY_PASSWORD

PowerShell example (current shell):

```powershell
$env:INFIPD_KEYSTORE_PATH = "C:\Users\$env:USERNAME\.keys\infinitepd-release.jks"
$env:INFIPD_KEYSTORE_PASSWORD = "YOUR_STORE_PASSWORD"
$env:INFIPD_KEY_ALIAS = "infinitepd"
$env:INFIPD_KEY_PASSWORD = "YOUR_KEY_PASSWORD"
```

## 3) Build signed release APK

```powershell
./gradlew android:assembleRelease
```

Output:
- android/build/outputs/apk/release/android-release.apk (signed when keys are configured)
- android/build/outputs/apk/release/android-release-unsigned.apk (if signing is not configured)

## Security notes

- Never commit real keystore files.
- Never commit android/keystore.properties with real passwords.
- Keep keystore backups in a safe encrypted location.
- Reuse the same keystore across PCs if you want upgrade-compatible app signatures.
