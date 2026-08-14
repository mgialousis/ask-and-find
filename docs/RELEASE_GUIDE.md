# Release Guide

This guide covers how to build and share release artifacts for Android and iOS.

## Prerequisites

- Flutter SDK installed
- Android SDK + Java installed (for APK/AAB)
- Xcode + CocoaPods installed (for iOS)
- `.env` configured for submissions/analytics (optional but recommended)

Create a `.env` file from `.env.example` and fill in values:
- `SHEETS_SPREADSHEET_ID`
- `SHEETS_CREDENTIALS_JSON` (one-line JSON)
- `POSTHOG_API_KEY` / `POSTHOG_HOST` (optional)

## Android Release

### APK (quick testing or direct install)
```bash
./scripts/android_build.sh --release --icons
```
Output:
- `build/app/outputs/flutter-apk/app-release.apk`

Use `--icons` after changing `assets/icons/app_icon_source.png`. It regenerates the Android and iOS launcher icon files before the APK build. Omit it for faster builds when the icon has not changed.

### App Bundle (Play Store)
```bash
flutter build appbundle --release
```
Output:
- `build/app/outputs/bundle/release/app-release.aab`

## iOS Release

### Build and run on device (Release)
```bash
./scripts/ios_deploy.sh --release <device-id>
```

### Archive for TestFlight/App Store
Open Xcode:
```bash
open ios/Runner.xcworkspace
```
Then:
- Product → Archive
- Distribute App → App Store Connect

## PostHog Verification (Optional)

To verify analytics in debug builds, set:
```
POSTHOG_ALLOW_DEBUG=true
```
Then run the app and trigger actions (new game, start round, end round) and check the PostHog Events stream.

## Submission Verification (Optional)

Append a test row to Google Sheets using the configured `.env`:
```bash
dart run scripts/test_sheets_submission.dart
```

## Notes

- Do not commit `.env` or credentials JSON.
- If submissions are enabled, ensure the Google Sheet is shared with the service account email.
- Android builds assume Java/Kotlin target 1.8. If you see JVM target mismatch errors, check `android/app/build.gradle.kts` and `android/build.gradle.kts`.
