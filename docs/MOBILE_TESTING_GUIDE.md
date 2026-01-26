# Mobile Testing Guide - Say & Find

This guide walks you through testing the "Say & Find" Flutter app on physical Android and iOS devices.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Android Device Testing](#android-device-testing)
3. [iOS Device Testing](#ios-device-testing)
4. [Testing Checklist](#testing-checklist)
5. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### General Requirements

**Flutter SDK:**
```bash
# Verify Flutter is installed and up to date
flutter --version

# Should show Flutter 3.10.4 or higher
```

**Project Dependencies:**
```bash
# Navigate to project directory
cd /Users/miltos/IdeaProjects/pes_vres

# Install dependencies
flutter pub get
```

**Verify Installation:**
```bash
# Check for any issues
flutter doctor

# You should see:
# [✓] Flutter (Channel stable, 3.10.4 or higher)
# [✓] Android toolchain (for Android testing)
# [✓] Xcode (for iOS testing - macOS only)
```

---

## Android Device Testing

### Step 1: Enable Developer Options on Android Device

1. **Go to Settings** on your Android phone
2. **Scroll to "About phone"** or "About device"
3. **Find "Build number"** (might be under "Software information")
4. **Tap "Build number" 7 times** rapidly
5. You'll see a message: "You are now a developer!"
6. **Go back to Settings**
7. **Find "Developer options"** (usually near bottom or under System)
8. **Enable "Developer options"** toggle at the top

### Step 2: Enable USB Debugging

1. **In Developer options**
2. **Enable "USB debugging"**
3. **Enable "Install via USB"** (if available)
4. **Enable "USB debugging (Security settings)"** (if available)

### Step 3: Connect Device to Computer

1. **Connect your Android phone** to your Mac/PC using a USB cable
2. **Unlock your phone**
3. **On your phone**: A popup will appear asking "Allow USB debugging?"
4. **Check "Always allow from this computer"**
5. **Tap "Allow"** or "OK"

### Step 4: Verify Device Connection

```bash
# In terminal, check if device is recognized
flutter devices

# You should see something like:
# Found 2 connected devices:
#   sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 13 (API 33)
#   Pixel 6 (mobile)            • 1A2B3C4D5E6F  • android-arm64  • Android 14 (API 34)
```

If you see your device listed, you're ready!

### Step 5: Run the App on Android

```bash
# Option 1: Run on the only connected device
flutter run

# Option 2: Run on a specific device (if multiple devices)
flutter run -d <device-id>

# Example:
flutter run -d 1A2B3C4D5E6F

# Option 3: Run in release mode (better performance)
flutter run --release
```

**What happens:**
- Flutter compiles the app (this takes 1-2 minutes the first time)
- App installs automatically on your phone
- App launches automatically
- Terminal shows logs and hot reload options

**Hot Reload (during development):**
- Press **`r`** in terminal to hot reload (fast refresh)
- Press **`R`** in terminal to hot restart (full restart)
- Press **`q`** to quit and stop the app

---

## iOS Device Testing

> **Note:** iOS testing requires macOS with Xcode installed.

### Step 1: Install Xcode (if not already installed)

1. **Open App Store** on your Mac
2. **Search for "Xcode"**
3. **Install Xcode** (this is large, ~10GB+, takes a while)
4. **Open Xcode** after installation
5. **Accept license agreement**
6. **Install additional components** when prompted

```bash
# Verify Xcode installation
xcodebuild -version

# Should show:
# Xcode 14.0 or higher
```

### Step 2: Set Up Signing & Capabilities

1. **Connect your iPhone** to your Mac with a USB cable
2. **Unlock your iPhone** and tap "Trust This Computer"
3. **Open the project in Xcode:**

```bash
# From project directory
open ios/Runner.xcworkspace
```

4. **In Xcode left sidebar**, click on "Runner" (blue icon at top)
5. **Select "Runner" target** (under TARGETS)
6. **Go to "Signing & Capabilities" tab**
7. **Check "Automatically manage signing"**
8. **Select your Team** from dropdown:
   - If you don't have a team, click "Add an Account"
   - Sign in with your Apple ID (free account works!)
9. **Bundle Identifier** should auto-fill (com.example.pesVres or similar)
10. **Provisioning Profile** should show "Xcode Managed Profile"

### Step 3: Trust Developer on iPhone

1. **On your iPhone**, go to **Settings → General → VPN & Device Management**
2. **Find your Apple ID** under "Developer App"
3. **Tap your Apple ID**
4. **Tap "Trust \<Your Apple ID\>"**
5. **Confirm** by tapping "Trust" again

### Step 4: Verify Device Connection

```bash
# Check if iPhone is recognized
flutter devices

# You should see:
# iPhone 14 Pro (mobile) • 00001234-ABCD1234ABCD1234 • ios • iOS 16.5
```

### Step 5: Run the App on iOS

```bash
# Option 1: Run on the only connected iOS device
flutter run

# Option 2: Run on specific device
flutter run -d <device-id>

# Example:
flutter run -d 00001234-ABCD1234ABCD1234

# Option 3: Run in release mode
flutter run --release
```

**First-time iOS build:**
- Takes 3-5 minutes (building iOS framework, installing CocoaPods)
- Subsequent builds are much faster (~30 seconds)

### Optional: Use the iOS helper script

```bash
# Release (default)
scripts/ios_deploy.sh --release <device-id>

# Debug
scripts/ios_deploy.sh --debug <device-id>
```

This script runs `flutter clean`, `flutter pub get`, `pod install`, and launches the app.

**If you get signing errors:**
```bash
# Clean and rebuild
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

---

## Testing Checklist

Use this checklist to systematically test all features on your physical device.

### ✅ Basic Navigation & Setup

- [ ] **App launches successfully** - No crashes, home screen appears
- [ ] **Home screen buttons work** - "New Game", "How to Play", "Settings" all navigate correctly
- [ ] **"How to Play" screen** - Scrolls smoothly, text is readable
- [ ] **Settings screen** - Toggle switches work, changes are saved
- [ ] **Close app and reopen** - Settings persist (sound, haptic, dark mode)

### ✅ Game Setup Screen

- [ ] **Number of teams selector** - Can select 2, 3, or 4 teams
- [ ] **Team cards appear/disappear** - Correct number of team input cards shown
- [ ] **Team name input** - Can enter custom names, default names populate
- [ ] **Team color picker** - Can open color picker, select colors
- [ ] **Duplicate colors prevented** - Previously selected colors are grayed out
- [ ] **Rounds selector** - Can choose 5, 7, or 10 rounds
- [ ] **Timer selector** - Can choose 30s, 45s, 60s, or 90s
- [ ] **Difficulty selector** - Can choose Easy, Medium, or Hard
- [ ] **Validation** - Cannot start game with empty team names or duplicate names
- [ ] **Start Game button** - Navigates to game screen

### ✅ Gameplay - Easy Difficulty (2 Teams, 5 Rounds, 60s)

**Setup:**
- Configure 2 teams: "Team A" and "Team B"
- Select 5 rounds, 60 seconds, Easy difficulty
- Tap "Start Game"

**Round 1 - Team A:**
- [ ] **"Pass device to Team A" screen appears**
- [ ] **Team name is highlighted** in team's color
- [ ] **Round counter shows "Round 1 of 5"**
- [ ] **Timer info shows "60 seconds"**
- [ ] **Tap "Ready? Start Round"**
- [ ] **Question appears** (e.g., "Name days of the week", "Name common pets")
- [ ] **Question difficulty badge shows "EASY"**
- [ ] **Timer starts counting down from 60**
- [ ] **10 numbered chips appear** (1-10 in grid)
- [ ] **Chips are tappable and responsive**
- [ ] **Tap chip 1** - Answer reveals (e.g., "Monday")
- [ ] **Chip turns green with checkmark**
- [ ] **Found counter updates** (1/10)
- [ ] **Tap 5 more chips** - All reveal correctly
- [ ] **Found counter shows 6/10**
- [ ] **Timer changes color at 10s remaining** (orange)
- [ ] **Timer changes color at 5s remaining** (red)
- [ ] **Let timer expire** (or find remaining answers)

**Round Results:**
- [ ] **Round results dialog appears**
- [ ] **Shows team name** and team color
- [ ] **Shows points earned** (e.g., "6 of 10")
- [ ] **Tap "Show Answers"**
- [ ] **Found answers shown in green** with checkmarks
- [ ] **Missed answers shown in gray**
- [ ] **Source attribution shown** (e.g., "Source: Calendar")
- [ ] **Tap "Continue"**

**Round 2 - Team B:**
- [ ] **"Pass device to Team B" screen appears**
- [ ] **Round counter shows "Round 2 of 5"**
- [ ] **Different question appears** (not the same as Round 1)
- [ ] **Complete round** (tap some answers, let timer expire)
- [ ] **Round results show correctly**

**Rounds 3-5:**
- [ ] **Continue through remaining rounds**
- [ ] **Team rotation works** (alternates between Team A and Team B)
- [ ] **Different questions each round**
- [ ] **Scores accumulate correctly**

### ✅ Results Screen

After completing all 5 rounds:
- [ ] **"Game Over!" header appears**
- [ ] **Winner announcement** (e.g., "Team A Wins!" or "It's a Tie!")
- [ ] **Trophy/medal icon** for winner
- [ ] **Scoreboard shows both teams** sorted by score
- [ ] **Rank badges** (1st, 2nd) displayed correctly
- [ ] **Team colors** shown in scoreboard
- [ ] **Final scores accurate**

**Action Buttons:**
- [ ] **"Play Again" button** - Resets scores, navigates to game screen
- [ ] **Verify "Play Again"** - Scores are reset to 0, same teams/config
- [ ] **Complete one more round** to verify reset worked
- [ ] **Navigate back to results**
- [ ] **"New Setup" button** - Navigates to setup screen
- [ ] **"Share Results" button** - Shows formatted results in dialog
- [ ] **"Home" button** - Navigates to home screen

### ✅ Advanced Testing

**Test 3 Teams:**
- [ ] Setup with 3 teams
- [ ] Verify team rotation cycles through all 3
- [ ] Verify color picker prevents 3 duplicate colors
- [ ] Complete full game

**Test 4 Teams:**
- [ ] Setup with 4 teams
- [ ] Verify team rotation cycles through all 4
- [ ] Complete full game

**Test Different Timers:**
- [ ] Play round with 30s timer
- [ ] Play round with 45s timer
- [ ] Play round with 90s timer
- [ ] Verify warning colors appear at correct times

**Test Different Difficulties:**
- [ ] Play game on Medium difficulty
  - Expected questions: "Name planets", "Name programming languages", etc.
- [ ] Play game on Hard difficulty
  - Expected questions: "Name Shakespeare plays", "Name Greek gods", etc.
- [ ] Play game on Hard difficulty
  - Questions should vary across all difficulty levels

**Test Edge Cases:**
- [ ] **Find all 10 answers before timer expires**
  - Round should end immediately
  - Timer should stop
  - Full points awarded
- [ ] **Let timer expire without finding any answers**
  - Round results show 0/10
  - No points awarded
- [ ] **Use very long team names** (20+ characters)
  - Name should display correctly (truncate if needed)
- [ ] **Test tie scenario** - Both teams have same score
  - Results screen shows "It's a Tie!"
  - Both team names listed

**Test Settings Persistence:**
- [ ] Enable sound effects in Settings
- [ ] Close app completely (swipe away from app switcher)
- [ ] Reopen app
- [ ] Go to Settings
- [ ] Verify sound effects still enabled
- [ ] Repeat for haptic feedback and dark mode

**Test Interruptions:**
- [ ] During active round, lock the phone
- [ ] Unlock and verify timer paused/continued
- [ ] During active round, go to home screen
- [ ] Return to app - verify state preserved
- [ ] During active round, receive a phone call
- [ ] End call and verify game continues

**Test Performance:**
- [ ] Animations are smooth (no jank)
- [ ] Timer counts down accurately (±1 second precision)
- [ ] No lag when tapping answer chips
- [ ] Scrolling is smooth (How to Play, Results)
- [ ] App doesn't overheat device
- [ ] Battery drain is reasonable

### ✅ Visual & Accessibility

- [ ] **Text is readable** on phone screen (not too small)
- [ ] **Colors are distinguishable** (test with different team colors)
- [ ] **Buttons are large enough** to tap easily (40x40dp minimum)
- [ ] **Layout adapts** to phone orientation (portrait primarily)
- [ ] **Material Design 3** theme looks consistent
- [ ] **Typography hierarchy** is clear (titles, body, captions)
- [ ] **No UI elements cut off** or overlapping

---

## Troubleshooting

### Android Issues

**Issue: Device not showing in `flutter devices`**

**Solution:**
```bash
# 1. Verify USB debugging is enabled on phone
# 2. Try a different USB cable (some cables are charge-only)
# 3. Restart ADB server
flutter devices
adb kill-server
adb start-server
flutter devices

# 4. Check driver installation (Windows only)
# Install Android USB drivers from device manufacturer
```

**Issue: "Waiting for another flutter command to release the startup lock..."**

**Solution:**
```bash
# Kill any existing Flutter processes
killall -9 dart
killall -9 flutter

# Or delete the lock file
rm -rf /Users/miltos/.flutter/flutter.lock
```

**Issue: App installs but doesn't launch**

**Solution:**
```bash
# Clear app data and reinstall
flutter clean
flutter pub get
flutter run --release
```

**Issue: Hot reload not working**

**Solution:**
- Use hot restart instead (press `R` in terminal)
- Or restart app completely (`q` to quit, then `flutter run` again)

---

### iOS Issues

**Issue: "Unable to install..." or "Could not find an option named 'emulator'"**

**Solution:**
- Make sure iPhone is unlocked
- Disconnect and reconnect USB cable
- Trust the computer again on iPhone
- Restart Xcode

**Issue: "Code signing is required..."**

**Solution:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Go to Signing & Capabilities
4. Select your team (sign in with Apple ID if needed)
5. Clean and rebuild:
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

**Issue: "Untrusted Developer" when launching app**

**Solution:**
1. On iPhone: Settings → General → VPN & Device Management
2. Tap your Apple ID under Developer App
3. Tap "Trust \<Your Apple ID\>"
4. Confirm by tapping "Trust"

**Issue: "CocoaPods not installed" or pod install fails**

**Solution:**
```bash
# Install CocoaPods
sudo gem install cocoapods

# Or update existing installation
sudo gem update cocoapods

# Then reinstall pods
cd ios
pod deintegrate
pod install
cd ..
```

**Issue: Build fails with "No such module 'Flutter'"**

**Solution:**
```bash
# Clean derived data and rebuild
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

---

### General Issues

**Issue: `flutter doctor` shows errors**

**Solution:**
```bash
# Run doctor with verbose output
flutter doctor -v

# Follow the specific recommendations for each [!] or [✗]
# Common fixes:
# - Update Flutter: flutter upgrade
# - Accept Android licenses: flutter doctor --android-licenses
# - Install Xcode command line tools: xcode-select --install
```

**Issue: App crashes immediately on launch**

**Solution:**
```bash
# Check logs for crash details
flutter logs

# Or run in debug mode to see stack trace
flutter run --debug
```

**Issue: "Gradle build failed" (Android)**

**Solution:**
```bash
# Update Gradle wrapper
cd android
./gradlew wrapper --gradle-version 7.5
cd ..

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**If the error mentions JVM target mismatch (Java 1.8 vs Kotlin 17):**
- Ensure Java/Kotlin targets match in:
  - `android/app/build.gradle.kts` (`compileOptions` + `kotlinOptions`)
  - `android/build.gradle.kts` (`compilerOptions` for Kotlin, `JavaCompile` tasks)
- This repo is configured for Java/Kotlin 1.8 to align plugin modules.

---

## Quick Reference Commands

```bash
# List all connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode (best performance)
flutter run --release

# Run and show detailed logs
flutter run -v

# Clean build artifacts
flutter clean

# Reinstall dependencies
flutter pub get

# Check for issues
flutter doctor

# View real-time logs
flutter logs

# Stop running app
# Press 'q' in terminal, or:
flutter stop
```

---

## Next Steps After Testing

Once you've completed testing:

1. **Document any issues** you find (crashes, UI problems, performance issues)
2. **Take notes** on user experience improvements
3. **Decide whether to:**
   - Fix critical issues before Phase 3
   - Continue to Phase 3 (Domain & Data Layers)
   - Polish Phase 2 (animations, sounds)

---

## Summary

You should now be able to:
- ✅ Run the app on Android devices
- ✅ Run the app on iOS devices
- ✅ Test all game features systematically
- ✅ Troubleshoot common issues

**Ready to test?** Connect your device and run:
```bash
flutter devices
flutter run --release
```

Happy testing! 🎮
