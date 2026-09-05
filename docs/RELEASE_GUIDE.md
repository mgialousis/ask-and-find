# Release Guide

This guide covers how to build and share release artifacts for Android and iOS.

## Prerequisites

- Flutter SDK installed
- Android SDK + Java installed (for APK/AAB)
- Xcode + CocoaPods installed (for iOS)
- A deployed HTTPS submission endpoint, if community submissions are enabled
- A public PostHog project key, if optional analytics are enabled
- A private Android upload keystore for distributable Android builds

Never place a Google service-account JSON document in a Flutter asset or
`--dart-define`. Storage credentials belong only in the submission backend.

For Android store signing, copy `android/key.properties.example` to
`android/key.properties`, replace every placeholder, and keep both the real
properties file and keystore outside Git. Without this file, Gradle produces an
unsigned release artifact suitable only for local verification.

## Android Release

### APK (quick testing or direct install)
```bash
./scripts/android_build.sh --release --icons \
  --submissions-endpoint https://example.com/api/submissions
```
Output:
- `build/app/outputs/flutter-apk/app-release.apk`

Use `--icons` after changing `assets/icons/app_icon_source.png`. It regenerates the Android and iOS launcher icon files before the APK build. Omit it for faster builds when the icon has not changed.

### App Bundle (Play Store)
```bash
flutter build appbundle --release \
  --dart-define=SUBMISSIONS_ENDPOINT_URL=https://example.com/api/submissions
```
Output:
- `build/app/outputs/bundle/release/app-release.aab`

## iOS Release

### Build and run on device (Release)
```bash
./scripts/ios_deploy.sh --release \
  --submissions-endpoint https://example.com/api/submissions \
  <device-id>
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

To verify analytics in debug builds, pass:
```
--dart-define=POSTHOG_API_KEY=your_public_project_key
--dart-define=POSTHOG_ALLOW_DEBUG=true
```
Then run the app and trigger actions (new game, start round, end round) and check the PostHog Events stream.

## Submission Verification (Optional)

The mobile client posts to the contract in `docs/SUBMISSION_API.md`. Test the
maintainer-side Google Sheets connection separately with a gitignored `.env`:
```bash
dart run scripts/test_sheets_submission.dart
```

## Notes

- Do not commit `.env`, credentials JSON, signing stores, or `key.properties`.
- Never expose backend credentials to the mobile build process.
- If a backend writes to Google Sheets, grant its service account access only
  to the target sheet and enforce validation/rate limits at the API boundary.
- Android builds assume Java/Kotlin target 1.8. If you see JVM target mismatch errors, check `android/app/build.gradle.kts` and `android/build.gradle.kts`.
