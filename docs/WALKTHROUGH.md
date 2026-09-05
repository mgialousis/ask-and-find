# Ask & Find: two-minute walkthrough

[Back to overview](../README.md)

Run `flutter pub get` and `flutter run`. Leave analytics and submission
configuration unset for a completely offline core-game demonstration.

1. **New Game:** choose 2–4 teams. Give each a fictional name and a distinct
   color. Scroll through setup to configure rounds, timer, difficulty, and
   card language; the Start Game control stays available at the bottom.
2. **Handoff:** start the game and follow the instruction to give the device
   to the opposing team, who acts as the host for the guessing team.
3. **Show Question:** read the prompt, then tap the question card to start
   the countdown. The host sees the answer list and marks correct guesses.
4. **Scoring:** each answer has its own point value. The capture shows a
   programming-languages question with differently weighted answers. Cards
   are selected by the game, so the first question may differ on your device.
5. **End Turn:** finish early or let the timer expire, inspect the round
   summary, and Continue to hand over to the next team. End Game opens the
   final results instead.

<p>
  <img src="screenshots/01-home.png" width="240" alt="Home menu" />
  <img src="screenshots/02-setup.png" width="240" alt="Team setup and palette" />
  <img src="screenshots/03-playing.png" width="240" alt="Timed round and answer scoring" />
</p>

## Capture provenance

Captured September 2026 from the actual Android app in a disposable emulator,
using light mode and default demonstration teams. The debug build has the
app's normal debug banner disabled; these are not design mockups or evidence
of iOS/store-release validation. To reproduce them, follow the steps above
and use the emulator screenshot control. Keep private team names,
notifications, credentials, and locally queued submissions out of images.

Without a configured HTTPS backend, contributions stay in the local retry
queue. These screenshots demonstrate the offline game, not backend delivery
or analytics operation.
