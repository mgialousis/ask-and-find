# Initial Requirements – “Ask & Find” (English Version of Πες Βρες)

> This document specifies the first version of a Flutter application that replicates the functionality of the Greek party game app “Πες Βρες!” (Pes Vres), but fully in English. It should **match the core gameplay and feature set**, without copying any copyrighted branding, artwork, or question text from the original.

---

## 1. Product Overview

### 1.1 Concept

“Ask & Find” is a **local multiplayer party trivia game** played on a **single device** (phone or tablet).  
Players split into **2–4 teams**. Each round, one team tries to guess as many items as possible from a hidden list (e.g., “European capitals”) **before the timer expires**. Their correct guesses score points. After a fixed number of rounds, the team with the highest score wins.

This is effectively an **English clone of “Πες Βρες!”** in terms of functionality:

- Single-device, pass-and-play format  [oai_citation:0‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)
- 2–4 teams
- Each round uses a **card** with:
    - A prompt/question
    - A list of **10–15 possible answers**
    - The app **randomly selects 10 answers** to count as scoring answers for that round  [oai_citation:1‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)
- Adjustable **difficulty** and **timer**
- **Overtime / tie-breaker** round in case of overall draw  [oai_citation:2‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)
- Option to show the **source(s)** of the card’s content (e.g., Wikipedia)  [oai_citation:3‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)

All UI copy and game content for this new app should be **in English**.

### 1.2 Platforms

- **Primary targets**:
    - Android (min reasonably modern API, e.g., 21+ or as you deem appropriate)
    - iOS (current supported iOS versions)

- **Tech stack**:
    - **Flutter** (latest stable at dev time), null-safety enabled.
    - State management: use a modern pattern (e.g., Riverpod, Bloc, or similar) – implementer may choose, but should be consistent.
    - No backend required for v1; all data stored locally.

---

## 2. Core Gameplay Requirements

### 2.1 Game Flow (High-Level)

1. User launches app → sees **Home Screen**.
2. User taps **“New Game”**.
3. Game setup:
    - Choose number of teams (2–4).
    - Enter team names.
    - Select team colors (optional).
    - Choose number of rounds (e.g. 5, 7, 10; configurable).
    - Choose **difficulty**:
        - Easy / Medium / Hard.
    - Choose **round duration** (e.g. 30 / 45 / 60 / 90 seconds).
4. Start game:
    - For each round:
        - App determines **which team’s turn** it is (round-robin).
        - App selects a **card** based on difficulty:
            - From the card’s 10–15 possible answers, **randomly pick 10** that will count for this round.
            - Show **prompt/question** and **hidden list placeholders** (e.g., 10 bullet slots).
        - When players are ready, they tap **“Start”** to begin the timer.
        - As team members shout answers, a designated player taps items on the screen or enters them to mark them as **found**.
        - Timer counts down. When it hits zero:
            - Round ends automatically.
    - End of round:
        - App shows:
            - Number of found answers.
            - Which answers were found vs. missed.
            - Source(s) of the card’s data (optional toggle).
        - The team’s score is incremented by the number of correct answers found.
5. Repeat for the configured number of rounds.
6. End of game:
    - Show **scoreboard / leaderboard**:
        - All teams with total points.
    - If there is a **tie for first place**, trigger a **tie-breaker** mechanism:
        - Sudden-death or extra round between tied teams (details in 2.4).
    - Option to **share** result (e.g., screenshot / share text) via OS share sheet.

### 2.2 Card / Question Behavior

- Each **card**:
    - `prompt_en` (string): e.g., “Name European capital cities”
    - `answers_en` (array of 10–15 strings)
    - `difficulty` (enum: EASY, MEDIUM, HARD)
    - `source` (string, optional; e.g. “Source: Wikipedia”)
- At runtime, for each round:
    - App filters available cards by selected difficulty.
    - Chooses a card pseudo-randomly (avoid repeats within a session if possible).
    - From `answers_en` (10–15), **randomly select 10** answers to be scoring answers.
    - These 10 are the only valid answers that will award points **for this round**, even if the card has more potential answers.  [oai_citation:4‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)

> Note: Actual English prompts and answers will be **original** (not copied from Πες Βρες). This document only defines structure and behavior, not the exact content.

### 2.3 Team & Scoring Rules

- Number of teams:
    - Minimum: 2
    - Maximum: 4  [oai_citation:5‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)
- Each team has:
    - `name` (string)
    - `color` (for UI highlights)
    - `score` (integer, total correct answers across all rounds)

- Turn order:
    - Default: Team 1 → Team 2 → Team 3 → Team 4 → back to Team 1, etc.
    - Each round is associated with one team turn.

- Scoring:
    - For each round, team gains **1 point per correct answer found** (out of the 10 selected).
    - No negative points for wrong guesses.
    - At the end of all rounds, highest score wins.

### 2.4 Tie-Breaker / Overtime

If multiple teams are tied for **highest score**:

- App signals a **tie** and prompts to start **tie-breaker mode**.
- Tie-breaker mode:
    - Only tied teams participate.
    - App can:
        - Option A (simple): Add **one extra round** for each tied team, same rules (same timer, difficulty).
        - Option B (sudden death – optional enhancement): Alternating guesses on the same card; first team to miss a valid answer while the other still has valid answers loses.
- For initial requirements, **Option A (one extra round per tied team)** is acceptable and simpler:
    - Each tied team gets a full extra round.
    - Highest score after that extra round wins.
    - If still tied, repeat extra rounds until tie is broken.
- App should **label** these rounds as “Overtime” in UI.

This mirrors the “overtime in case of tie” feature in the original app.  [oai_citation:6‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)

---

## 3. Screens & UX

### 3.1 Splash / Launch Screen

- Simple logo + app name (“Ask & Find” or TBD).
- Short loading state if needed while initializing local DB / assets.

### 3.2 Home Screen

Components:

- App title/logo.
- Primary CTA: **“New Game”**.
- Secondary CTAs:
    - **“How to Play”** (help/tutorial).
    - **“Settings”**.
    - (Optional) **“About”** / Credits.
- (Optional) Display a fun tagline, e.g., “The ultimate party trivia game!”.

### 3.3 New Game Setup Wizard

Could be one screen or multiple steps. Required inputs:

1. **Number of teams**:
    - 2, 3, or 4 (buttons or a stepper).
2. **Team details**:
    - For each team:
        - Name (text input; default: “Team A”, “Team B”, etc.).
        - Color (predefined palette).
3. **Rounds & Timer**:
    - Number of rounds:
        - Provide a small set of presets + maybe a custom option:
            - 5 / 7 / 10 (or similar).
    - Round duration:
        - 30 / 45 / 60 / 90 seconds (radio buttons or dropdown).
4. **Difficulty**:
    - Easy / Medium / Hard.
5. **Confirm & Start**:
    - Summary of choices.
    - “Start Game” button.

### 3.4 Game Screen – Active Round

Shown when playing a round for the current team.

Elements:

- **Header area**:
    - Current team name + color indicator.
    - Round counter (e.g., “Round 3 of 10”).
- **Prompt area**:
    - The card’s **question/prompt** in large, readable text.
- **Answers area**:
    - A list of 10 slots representing the selected answers.
    - Initially, slots are hidden or blank (e.g., “Answer 1”, “Answer 2”).
    - When an answer is found, the corresponding slot reveals the answer text and is visually marked.
    - Implementation detail:
        - App can either show all 10 answers as tappable chips for the facilitator, or use a text field & matching logic. For v1, **tappable chips** (where the device holder taps when someone says that answer) is simpler and more robust than parsing speech or text.
- **Timer**:
    - Visible countdown timer (MM:SS).
    - Distinct visual when approaching 0 (e.g., flashing or bold).
- **Controls**:
    - Pre-start state:
        - “Start Round” button (trigger timer & start).
    - During round:
        - “Pause” (optional).
        - “End Round” (for early termination).
    - Post-round:
        - “Next Team” / “Continue”.
- **End-of-round popup/section**:
    - Show:
        - Total answers found this round.
        - List of all 10 selected answers, highlighting found vs missed.
        - Optional: button “Show sources” that reveals the `source` text.

### 3.5 Scoreboard / Between Rounds Screen

- After each round, briefly show:
    - Current team scores in a simple table/list.
    - Highlight the team that just played and how many points they earned that round.
    - “Continue to Next Round” button.

### 3.6 Final Results Screen

- Display all teams sorted by score (highest first).
- Highlight the **winner**:
    - E.g. “Winner: Team Green – 27 points!”
- If there was a tie-breaker, mention “Won in overtime”.
- Provide:
    - “Play Again” (keep previous setup but reset scores).
    - “New Setup” (return to setup).
    - “Share Result”:
        - Use OS sharing sheet with text like:
            - “We just played ‘Ask & Find’ – Winner: Team Green with 27 points!”

The original app allows sharing wins on social platforms; here we use generic share to respect platform-neutral design.  [oai_citation:7‡Πες Βρες App](https://www.pesvres.com/?utm_source=chatgpt.com)

### 3.7 Settings Screen

Options:

- Sound effects on/off.
- Haptic feedback on/off (where supported).
- (Optional) Dark mode toggle (or use system theme).
- “Language”:
    - For v1, only **English** is implemented, but design the UI to be **i18n ready** for future languages.
- “Restore defaults” button.

### 3.8 How to Play / Help Screen

Explain briefly, in English:

- How to create teams.
- How rounds work (prompt + 10 answers, countdown).
- How scoring works.
- That **one device is enough** for all players.  [oai_citation:8‡Google Play](https://play.google.com/store/apps/details?hl=el&id=pes.vres&utm_source=chatgpt.com)
- How tie-breaker/overtime works.

---

## 4. Data & Storage

### 4.1 Data Model (Initial)

Define strong typed models (e.g., Dart classes):

```dart
class CardItem {
  final String id;
  final String promptEn;
  final List<String> answersEn; // length 10–15
  final Difficulty difficulty;  // enum: easy, medium, hard
  final String? source;         // nullable
}

class Team {
  final String id;
  String name;
  Color color;
  int score;
}

class RoundResult {
  final int roundNumber;
  final String teamId;
  final String cardId;
  final List<String> selectedAnswers;    // the 10 answers chosen for scoring
  final List<String> foundAnswers;       // subset of selectedAnswers
  final int pointsEarned;
  final bool isOvertime;
}
```
## 5. Non-Functional Requirements

### 5.1 Performance & Responsiveness
- Must run smoothly on typical mid-range Android and iOS devices.
- Animations, if any, should be lightweight and non-blocking.
- Timer must be accurate to within ~100ms of real time.

### 5.2 Accessibility & UX
- Text should be readable on phones and tablets.
- Buttons and tappable areas large enough for quick party play.
- Color usage should consider color-blind friendliness (e.g., pairing color with labels/icons).

### 5.3 Internationalization
- App text/UI copy in English only for v1.
- However, code structure should allow new locales (e.g., using Flutter’s localization patterns).

### 5.4 Legal & IP
- Do **not** copy:
    - Exact question/card texts
    - Brand name “Πες Βρες”
    - Game graphics or logo assets from the original app.
- Use **original English prompts and answers**, and new branding (e.g., “Ask & Find”).

### 5.5 Code Style & Architecture Guidelines
To ensure maintainable, scalable, and readable code, the following style and architectural patterns must be applied throughout the project:

#### 5.5.1 Folder Structure & Separation of Concerns
- Use a well-organized Flutter project structure that enforces clear separation between:
    - `presentation` (UI widgets, screens, state)
    - `domain` (models, use-cases, logic)
    - `data` (repositories, local storage, API adapters)
    - `core` (theme, routing, utilities)
- Avoid mixing UI code with business logic or data access.
- Do not make network/storage calls directly from UI widgets.

#### 5.5.2 Widgets & UI Guidelines
- Prefer **small, focused, and composable widgets** rather than large monolithic widget trees.
- Use **flexible layouts** (e.g. `Expanded`, `Flexible`, `Spacer`, `LayoutBuilder`, `MediaQuery`) instead of hard-coded pixel sizes.
- The UI must adapt to both **phones** and **tablets**.
- Avoid absolute positioning unless necessary.

#### 5.5.3 State Management
- Use a modern state management approach (e.g., **Riverpod**, **Bloc**, or **Provider**).
- State and logic must not live inside widget `build()` methods.
- Do not use global mutable state.

#### 5.5.4 Logging & Debugging
- Use:
  ```dart
  import 'dart:developer' show log;
