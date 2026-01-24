# PostHog Analytics Integration Plan

## Goals
- Track gameplay usage and drop‑offs without collecting PII.
- Measure core funnels (setup → play → round end → game end).
- Observe feature usage (difficulty filters, languages, submissions, sound/haptics).
- Keep analytics optional (opt‑out) and safe for release builds only.

## Scope (What We Will Track)
### Core Events
- `app_opened` (cold start)
- `new_game_started` (config: rounds, duration, teams count, selected difficulties)
- `round_preview_shown` (round number, team index)
- `round_started` (difficulty, card_id, locale)
- `round_ended` (found_count, points_earned, duration_seconds)
- `game_completed` (total_rounds, winner, total_points)
- `game_abandoned` (phase at exit)

### UI / Feature Events
- `question_refreshed` (difficulty, card_id, locale)
- `answer_toggled` (selected: true/false, points)
- `language_changed` (locale)
- `settings_changed` (sound, haptics, dark_mode)
- `submission_opened` (mode: new/correction)
- `submission_submitted` (mode, result: success/savedLocally/failed)

### Properties (Standard)
- `app_version`, `build_number`
- `platform` (ios/android), `os_version`
- `locale`, `timezone`
- `device_id` (generated UUID, stored locally)
- `release_channel` (debug/profile/release)

## Privacy & Compliance
- Do not send names, emails, or custom card content.
- If a user enters an email in submissions, keep it in Google Sheets only.
- Provide a Settings toggle: **Analytics** (default on; opt‑out).
- Respect opt‑out by disabling PostHog capture at runtime.
- Update README/Privacy copy if required.

## Implementation Steps
### 1) Add Dependencies
- Use `posthog_flutter` (preferred) or `posthog` if you want manual control.
- Add to `pubspec.yaml`.

### 2) Configure Secrets
- Add a config file (e.g., `lib/core/config/analytics_config.dart`) with:
  - `posthogApiKey`
  - `posthogHost` (default: `https://app.posthog.com`)
- Load values via `--dart-define` or `.env` (avoid hardcoding).

### 3) Initialize PostHog
- Initialize in `main.dart` before `runApp`.
- Example options:
  - `captureApplicationLifecycleEvents: true`
  - `optOut: false` (but gate with user setting)
- Set super properties: version, build, platform, locale.

### 4) Add User/Device Identity
- Generate and persist a UUID on first launch (SharedPreferences).
- Call `Posthog().identify(deviceId)` only after consent.

### 5) Implement Analytics Service
- Create `lib/core/analytics/analytics_service.dart` with:
  - `capture(event, properties)`
  - `setEnabled(bool enabled)`
  - `setUserProperties(map)`
- Use this service in providers/screens to avoid direct PostHog calls.

### 6) Wire Events
- Hook events in state notifiers and key screens:
  - Game start/end, round start/end, refresh question, answer toggles.
  - Submission success/failure.
  - Settings changes (analytics opt‑out).

### 7) Add Settings Toggle
- Add an **Analytics** switch in Settings.
- Store the preference in the settings provider.
- When off:
  - Call `Posthog().optOut()`.
  - Stop all `capture` calls in `analytics_service`.

### 8) QA / Verification
- Use PostHog debug console to confirm event payloads.
- Validate opt‑out: no events when toggle is off.
- Test both iOS and Android builds.

## Event Schema (Draft)
| Event | Required Properties |
|------|----------------------|
| `new_game_started` | `rounds`, `duration_seconds`, `teams_count`, `difficulties` |
| `round_started` | `round`, `team_index`, `difficulty`, `card_id`, `locale` |
| `round_ended` | `round`, `team_index`, `found_count`, `points_earned` |
| `game_completed` | `total_rounds`, `winner`, `total_points` |
| `question_refreshed` | `difficulty`, `card_id`, `locale` |
| `submission_submitted` | `mode`, `result`, `locale` |

## Rollout Plan
1. Add analytics behind a feature flag (Settings toggle).
2. Release to TestFlight/alpha first; monitor event volume.
3. Gradually enable by default after validation.

## Delivery Log
### Day 1 - Foundation (Complete)
- Added `posthog_flutter` dependency and `.env`/dart-define config support.
- Built `AnalyticsService` with opt-out, device ID, and super properties.
- Initialized analytics in `main.dart` and added `app_opened`.
- Added Settings → Privacy → Analytics toggle and persistence.
- Updated build scripts to pass `POSTHOG_*` dart defines.

### Day 2 - Event Wiring (Complete)
- Added core game events (preview, start, answer toggle, end, completion, refresh).
- Added submission events (opened, submitted) and settings/language change tracking.
- Added guarded `game_abandoned` capture on mid-game resets.

### Day 3 - Docs & QA (Complete)
- Added README analytics section and opt-out notes.
- Confirmed localization updates for new Settings strings.

## Open Questions
- PostHog project key + host URL?
- Should analytics default be ON for all users or only new installs?
- Any legal copy to add to Settings or About screen?
