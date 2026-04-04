# Internationalization Plan: Adding Spanish Language Support

## Overview

This plan details how to add Spanish language support to the "Ask & Find" app, making it fully bilingual (English/Spanish) with the ability to easily add more languages in the future.

## Progress (current)

Completed:
- Localization infrastructure is in place (`flutter_localizations`, `intl`, `l10n.yaml`, generated files under `lib/l10n/`).
- Locale persistence via `locale_provider` and MaterialApp localization wiring.
- Day 2 screens localized (home, settings, setup).
- Day 3 screens localized (game flow, prompt card, round results, answer chips, team indicator).
- Day 4 screens localized (results, scoreboard, score card).
- Card model supports locale-specific prompt/answers (`promptEs`, `answersEs`) with locale-aware getters.
- Card selection and answers now respect locale.
- Added `languageScope` per card with default `["en","es"]` and locale filtering for selection.
- Spanish translations added for all cards in `assets/cards.json`.
- Added a language-sensitive prompt validator script: `scripts/flag_language_sensitive_cards.py`.
- Added a localization widget test for Spanish UI.

Open follow-ups:
- Tag any language-specific cards as `languageScope: ["en"]` or `["es"]` as they are added.
- Run a Spanish UI pass for layout/overflow.

---

## Scope Analysis

### Files Requiring Localization: 20 files
### Total Strings to Localize: ~70+ distinct text elements
### Cards Database: 75 cards with prompts and answers

### String Categories:
| Category | Count | Examples |
|----------|-------|----------|
| Button labels | ~15 | "New Game", "Start Game", "Continue" |
| Headers/Titles | ~12 | "Game Setup", "Settings", "Game Over!" |
| Instructions | ~15 | How to Play content |
| Dynamic labels | ~8 | "Round 1 of 5", "3 points" |
| Validation messages | ~3 | "Team name cannot be empty" |
| Settings labels | ~6 | "Sound Effects", "Dark Mode" |

---

## Implementation Plan

### Phase 1: Setup Flutter Localization Infrastructure

#### Task 1.1: Add Dependencies

**File:** `pubspec.yaml`

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

flutter:
  generate: true  # Enable code generation for localization
```

#### Task 1.2: Create l10n Configuration

**File:** `l10n.yaml` (create in project root)

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

#### Task 1.3: Create Localization Directory Structure

```
lib/
└── l10n/
    ├── app_en.arb    # English strings
    └── app_es.arb    # Spanish strings
```

---

### Phase 2: Create ARB Files with All Strings

#### Task 2.1: English ARB File

**File:** `lib/l10n/app_en.arb`

```json
{
  "@@locale": "en",

  "appTitle": "Ask & Find",
  "appTagline": "The Ultimate Party Trivia Game",

  "newGame": "New Game",
  "howToPlay": "How to Play",
  "settings": "Settings",
  "startGame": "Start Game",
  "continue_": "Continue",
  "playAgain": "Play Again",
  "newSetup": "New Setup",
  "shareResults": "Share Results",
  "home": "Home",
  "close": "Close",
  "endGame": "End Game",
  "endTurn": "End Turn",
  "showQuestion": "Show Question",
  "showAnswers": "Show Answers",
  "hideAnswers": "Hide Answers",
  "restoreDefaults": "Restore Defaults",

  "gameSetup": "Game Setup",
  "numberOfTeams": "Number of Teams",
  "teamSetup": "Team Setup",
  "gameSettings": "Game Settings",
  "numberOfRounds": "Number of Rounds",
  "roundDuration": "Round Duration",
  "difficulty": "Difficulty",
  "teamName": "Team Name",
  "teamColor": "Team Color",
  "enterTeamName": "Enter team name",

  "team": "Team",
  "teams": "Teams",
  "teamWithNumber": "Team {number}",
  "@teamWithNumber": {
    "placeholders": {
      "number": {"type": "int"}
    }
  },

  "easy": "Easy",
  "medium": "Medium",
  "hard": "Hard",

  "seconds30": "30s",
  "seconds45": "45s",
  "seconds60": "60s",
  "seconds90": "90s",

  "roundOf": "Round {current} of {total}",
  "@roundOf": {
    "placeholders": {
      "current": {"type": "int"},
      "total": {"type": "int"}
    }
  },

  "findAnswersInTime": "Find 10 answers in {seconds} seconds",
  "@findAnswersInTime": {
    "placeholders": {
      "seconds": {"type": "int"}
    }
  },

  "passDeviceMessage": "It's {currentTeam} turn, pass device to {nextTeam}",
  "@passDeviceMessage": {
    "placeholders": {
      "currentTeam": {"type": "String"},
      "nextTeam": {"type": "String"}
    }
  },

  "tapToStartTimer": "Tap the card to start the timer",

  "gameOver": "Game Over!",
  "teamWins": "{teamName} Wins!",
  "@teamWins": {
    "placeholders": {
      "teamName": {"type": "String"}
    }
  },
  "itsATie": "It's a Tie!",
  "noWinner": "No winner",
  "noScoresRecorded": "No scores recorded",

  "points": "{count, plural, =1{1 point} other{{count} points}}",
  "@points": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },

  "pts": "{count, plural, =1{1 pt} other{{count} pts}}",
  "@pts": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },

  "roundComplete": "Round Complete!",
  "foundOf": "Found {found} of {total}",
  "@foundOf": {
    "placeholders": {
      "found": {"type": "int"},
      "total": {"type": "int"}
    }
  },
  "scoresSoFar": "Scores So Far",
  "finalScores": "Final Scores",

  "foundWithCount": "Found ({count}) ({points} pts)",
  "@foundWithCount": {
    "placeholders": {
      "count": {"type": "int"},
      "points": {"type": "int"}
    }
  },
  "missedWithCount": "Missed ({count})",
  "@missedWithCount": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },

  "rank1st": "1st",
  "rank2nd": "2nd",
  "rank3rd": "3rd",
  "rankNth": "{rank}th",
  "@rankNth": {
    "placeholders": {
      "rank": {"type": "int"}
    }
  },

  "settingsTitle": "Settings",
  "audio": "Audio",
  "haptics": "Haptics",
  "appearance": "Appearance",
  "language": "Language",
  "soundEffects": "Sound Effects",
  "soundEffectsDesc": "Play sounds during gameplay",
  "hapticFeedback": "Haptic Feedback",
  "hapticFeedbackDesc": "Vibrate on interactions",
  "darkMode": "Dark Mode",
  "darkModeDesc": "Coming soon in a future update",
  "settingsRestored": "Settings restored to defaults",
  "version": "Version {number}",
  "@version": {
    "placeholders": {
      "number": {"type": "String"}
    }
  },

  "validationNameEmpty": "Team name cannot be empty",
  "validationNameDuplicate": "Team name must be unique",
  "validationFixErrors": "Please fix validation errors before starting",

  "howToPlayTitle": "How to Play",
  "step1Title": "Set Up Teams",
  "step1Desc": "Create 2-4 teams and choose unique names and colors for each team. Each team will take turns guessing answers.",
  "step2Title": "Read the Prompt",
  "step2Desc": "Each round, the active team sees a prompt (like \"Name European capital cities\"). Their goal is to guess 10 correct answers from a hidden list.",
  "step3Title": "Beat the Clock",
  "step3Desc": "Teams have a time limit (30-90 seconds) to find as many answers as possible. Tap the hidden chips to reveal answers when you guess correctly.",
  "step4Title": "Score Points",
  "step4Desc": "Each correct answer found earns 1 point. There are no penalties for wrong guesses, so keep trying! Only the 10 selected answers for that round count.",
  "step5Title": "Take Turns",
  "step5Desc": "Teams take turns playing rounds until all configured rounds are complete. The game alternates between teams in order.",
  "step6Title": "Win the Game",
  "step6Desc": "After all rounds, the team with the most points wins! If there's a tie for first place, overtime rounds determine the winner.",

  "proTips": "Pro Tips",
  "tip1": "Communication is key! Discuss answers with your team.",
  "tip2": "Think of multiple variations of an answer (e.g., \"USA\" vs \"United States\").",
  "tip3": "Watch the timer! The last 10 seconds are critical.",
  "tip4": "Learn from revealed answers at the end of each round.",

  "shareTitle": "Ask & Find - Game Results",
  "shareWinner": "Winner:",
  "shareTie": "Tie between:",
  "shareScore": "Score:",
  "shareFinalStandings": "Final Standings:",

  "english": "English",
  "spanish": "Spanish"
}
```

#### Task 2.2: Spanish ARB File

**File:** `lib/l10n/app_es.arb`

```json
{
  "@@locale": "es",

  "appTitle": "Di y Encuentra",
  "appTagline": "El Juego de Trivia Definitivo",

  "newGame": "Nuevo Juego",
  "howToPlay": "Cómo Jugar",
  "settings": "Ajustes",
  "startGame": "Iniciar Juego",
  "continue_": "Continuar",
  "playAgain": "Jugar de Nuevo",
  "newSetup": "Nueva Configuración",
  "shareResults": "Compartir Resultados",
  "home": "Inicio",
  "close": "Cerrar",
  "endGame": "Terminar Juego",
  "endTurn": "Terminar Turno",
  "showQuestion": "Mostrar Pregunta",
  "showAnswers": "Mostrar Respuestas",
  "hideAnswers": "Ocultar Respuestas",
  "restoreDefaults": "Restaurar Valores",

  "gameSetup": "Configuración del Juego",
  "numberOfTeams": "Número de Equipos",
  "teamSetup": "Configuración de Equipos",
  "gameSettings": "Ajustes del Juego",
  "numberOfRounds": "Número de Rondas",
  "roundDuration": "Duración de Ronda",
  "difficulty": "Dificultad",
  "teamName": "Nombre del Equipo",
  "teamColor": "Color del Equipo",
  "enterTeamName": "Ingrese nombre del equipo",

  "team": "Equipo",
  "teams": "Equipos",
  "teamWithNumber": "Equipo {number}",

  "easy": "Fácil",
  "medium": "Medio",
  "hard": "Difícil",

  "seconds30": "30s",
  "seconds45": "45s",
  "seconds60": "60s",
  "seconds90": "90s",

  "roundOf": "Ronda {current} de {total}",
  "findAnswersInTime": "Encuentra 10 respuestas en {seconds} segundos",
  "passDeviceMessage": "Es el turno de {currentTeam}, pasa el dispositivo a {nextTeam}",
  "tapToStartTimer": "Toca la tarjeta para iniciar el temporizador",

  "gameOver": "¡Fin del Juego!",
  "teamWins": "¡{teamName} Gana!",
  "itsATie": "¡Es un Empate!",
  "noWinner": "Sin ganador",
  "noScoresRecorded": "Sin puntuaciones registradas",

  "points": "{count, plural, =1{1 punto} other{{count} puntos}}",
  "pts": "{count, plural, =1{1 pto} other{{count} ptos}}",

  "roundComplete": "¡Ronda Completa!",
  "foundOf": "Encontradas {found} de {total}",
  "scoresSoFar": "Puntuaciones Hasta Ahora",
  "finalScores": "Puntuaciones Finales",

  "foundWithCount": "Encontradas ({count}) ({points} ptos)",
  "missedWithCount": "Falladas ({count})",

  "rank1st": "1°",
  "rank2nd": "2°",
  "rank3rd": "3°",
  "rankNth": "{rank}°",

  "settingsTitle": "Ajustes",
  "audio": "Audio",
  "haptics": "Vibración",
  "appearance": "Apariencia",
  "language": "Idioma",
  "soundEffects": "Efectos de Sonido",
  "soundEffectsDesc": "Reproducir sonidos durante el juego",
  "hapticFeedback": "Vibración Háptica",
  "hapticFeedbackDesc": "Vibrar en las interacciones",
  "darkMode": "Modo Oscuro",
  "darkModeDesc": "Próximamente en una actualización futura",
  "settingsRestored": "Ajustes restaurados a valores predeterminados",
  "version": "Versión {number}",

  "validationNameEmpty": "El nombre del equipo no puede estar vacío",
  "validationNameDuplicate": "El nombre del equipo debe ser único",
  "validationFixErrors": "Por favor corrige los errores de validación antes de comenzar",

  "howToPlayTitle": "Cómo Jugar",
  "step1Title": "Configura los Equipos",
  "step1Desc": "Crea de 2 a 4 equipos y elige nombres y colores únicos para cada equipo. Cada equipo se turnará para adivinar respuestas.",
  "step2Title": "Lee la Pregunta",
  "step2Desc": "Cada ronda, el equipo activo ve una pregunta (como \"Nombra capitales europeas\"). Su objetivo es adivinar 10 respuestas correctas de una lista oculta.",
  "step3Title": "Vence al Reloj",
  "step3Desc": "Los equipos tienen un límite de tiempo (30-90 segundos) para encontrar tantas respuestas como sea posible. Toca las fichas ocultas para revelar respuestas cuando adivines correctamente.",
  "step4Title": "Gana Puntos",
  "step4Desc": "Cada respuesta correcta encontrada gana 1 punto. No hay penalizaciones por respuestas incorrectas, ¡así que sigue intentando! Solo cuentan las 10 respuestas seleccionadas para esa ronda.",
  "step5Title": "Toma Turnos",
  "step5Desc": "Los equipos se turnan para jugar rondas hasta que se completen todas las rondas configuradas. El juego alterna entre equipos en orden.",
  "step6Title": "Gana el Juego",
  "step6Desc": "¡Después de todas las rondas, el equipo con más puntos gana! Si hay un empate en el primer lugar, las rondas de tiempo extra determinan al ganador.",

  "proTips": "Consejos Pro",
  "tip1": "¡La comunicación es clave! Discute las respuestas con tu equipo.",
  "tip2": "Piensa en múltiples variaciones de una respuesta (ej., \"EE.UU.\" vs \"Estados Unidos\").",
  "tip3": "¡Vigila el temporizador! Los últimos 10 segundos son críticos.",
  "tip4": "Aprende de las respuestas reveladas al final de cada ronda.",

  "shareTitle": "Di y Encuentra - Resultados del Juego",
  "shareWinner": "Ganador:",
  "shareTie": "Empate entre:",
  "shareScore": "Puntuación:",
  "shareFinalStandings": "Posiciones Finales:",

  "english": "Inglés",
  "spanish": "Español"
}
```

---

### Phase 3: Update App Configuration

#### Task 3.1: Update MaterialApp

**File:** `lib/app.dart`

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      // ... existing config ...

      // Add localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Supported locales
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],

      // Current locale from provider
      locale: locale,
    );
  }
}
```

#### Task 3.2: Create Locale Provider

**File:** `lib/presentation/state/locale_provider.dart`

```dart
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'en';
    state = Locale(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    state = locale;
  }
}
```

---

### Phase 4: Update All Screens to Use Localized Strings

#### Task 4.1: Usage Pattern

Replace all hardcoded strings with localized versions:

```dart
// Before
Text('New Game')

// After
import 'package:pes_vres/l10n/app_localizations.dart';

Text(AppLocalizations.of(context).newGame)
```

For strings with parameters:
```dart
// Before
Text('Round $current of $total')

// After
Text(AppLocalizations.of(context).roundOf(current, total))
```

For pluralization:
```dart
// Before
Text('$count ${count == 1 ? 'point' : 'points'}')

// After
Text(AppLocalizations.of(context).points(count))
```

#### Task 4.2: Files to Update (in order)

1. `lib/app.dart` - Add localization setup
2. `lib/presentation/screens/home/home_screen.dart`
3. `lib/presentation/screens/settings/settings_screen.dart` - Add language selector
4. `lib/presentation/screens/setup/setup_screen.dart`
5. `lib/presentation/screens/setup/team_setup_section.dart`
6. `lib/presentation/screens/setup/game_config_section.dart`
7. `lib/presentation/screens/game/game_screen.dart`
8. `lib/presentation/screens/game/widgets/game_header.dart`
9. `lib/presentation/screens/game/widgets/prompt_card.dart`
10. `lib/presentation/screens/game/widgets/round_result_dialog.dart`
11. `lib/presentation/screens/results/results_screen.dart`
12. `lib/presentation/screens/results/widgets/scoreboard_widget.dart`
13. `lib/presentation/screens/results/widgets/score_card.dart`
14. `lib/presentation/screens/how_to_play/how_to_play_screen.dart`
15. `lib/presentation/widgets/game/answer_chip.dart`
16. `lib/presentation/widgets/game/team_indicator.dart`

---

### Phase 5: Add Language Selector to Settings

#### Task 5.1: Update Settings Screen

Add a language selector section:

```dart
// In settings_screen.dart
_SectionHeader(title: AppLocalizations.of(context).language),
ListTile(
  leading: const Icon(Icons.language),
  title: Text(AppLocalizations.of(context).language),
  subtitle: Text(_getCurrentLanguageName(context, currentLocale)),
  trailing: const Icon(Icons.chevron_right),
  onTap: () => _showLanguageDialog(context, ref),
),
```

Language selection dialog:
```dart
void _showLanguageDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context).language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).english),
            leading: Radio<Locale>(
              value: const Locale('en'),
              groupValue: ref.watch(localeProvider),
              onChanged: (locale) {
                ref.read(localeProvider.notifier).setLocale(locale!);
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).spanish),
            leading: Radio<Locale>(
              value: const Locale('es'),
              groupValue: ref.watch(localeProvider),
              onChanged: (locale) {
                ref.read(localeProvider.notifier).setLocale(locale!);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

### Phase 6: Localize Cards Database

#### Task 6.1: Update Card Model

**File:** `lib/domain/entities/card_item.dart`

```dart
class CardItem {
  final String id;
  final String promptEn;
  final String? promptEs;  // Add Spanish prompt
  final List<String> answersEn;
  final List<String>? answersEs;  // Add Spanish answers
  final List<String> languageScope; // ["en"], ["es"], or ["en","es"]
  final Difficulty difficulty;
  final String? source;
  final Map<String, int>? answerPoints;

  // Method to get localized prompt
  String getPrompt(Locale locale) {
    if (locale.languageCode == 'es' && promptEs != null) {
      return promptEs!;
    }
    return promptEn;
  }

  // Method to get localized answers
  List<String> getAnswers(Locale locale) {
    if (locale.languageCode == 'es' && answersEs != null) {
      return answersEs!;
    }
    return answersEn;
  }

  // Locale gating for language-dependent prompts
  bool supportsLocale(Locale locale) {
    return languageScope.contains(locale.languageCode);
  }
}
```

#### Task 6.2: Update cards.json Structure

```json
{
  "id": "1",
  "promptEn": "Name 10 most populous countries in the world",
  "promptEs": "Nombra los 10 países más poblados del mundo",
  "answersEn": ["India", "China", "United States", ...],
  "answersEs": ["India", "China", "Estados Unidos", ...],
  "difficulty": "medium",
  "source": "Source: World population estimates 2025",
  "languageScope": ["en", "es"]
}
```

#### Task 6.3: Update Cards Repository

Ensure the repository returns localized content based on current locale and language scope.

---

### Phase 7: Testing

#### Task 7.1: Test Checklist

- [ ] App launches in English by default
- [ ] Language selector appears in Settings
- [ ] Switching to Spanish updates all UI text
- [ ] Language preference persists after app restart
- [ ] All screens display correctly in both languages
- [ ] Pluralization works correctly (1 point vs 2 points / 1 punto vs 2 puntos)
- [ ] Dynamic strings with parameters work correctly
- [ ] Cards display in selected language
- [ ] Share text uses correct language
- [ ] No text overflow issues in Spanish (typically longer text)

#### Task 7.2: Add Localization Tests

```dart
testWidgets('displays Spanish text when locale is Spanish', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => LocaleNotifier()..setLocale(const Locale('es'))),
      ],
      child: const App(),
    ),
  );

  expect(find.text('Nuevo Juego'), findsOneWidget);
});
```

---

## Implementation Order

### Day 1: Infrastructure Setup
1. Add dependencies to pubspec.yaml
2. Create l10n.yaml configuration
3. Create lib/l10n/ directory
4. Create app_en.arb with all strings
5. Create app_es.arb with all translations
6. Run `flutter gen-l10n` to generate code
7. Create locale_provider.dart
8. Update app.dart with localization config

### Day 2: Screen Updates (Part 1)
1. Update home_screen.dart
2. Update settings_screen.dart (add language selector)
3. Update setup_screen.dart
4. Update team_setup_section.dart
5. Update game_config_section.dart

### Day 3: Screen Updates (Part 2)
1. Update game_screen.dart
2. Update game_header.dart
3. Update prompt_card.dart
4. Update round_result_dialog.dart
5. Update answer_chip.dart
6. Update team_indicator.dart

### Day 4: Screen Updates (Part 3) & Cards
1. Update results_screen.dart
2. Update scoreboard_widget.dart
3. Update score_card.dart
4. Update how_to_play_screen.dart
5. Update CardItem model
6. Add Spanish translations to cards.json (all cards)
7. Add languageScope and locale filtering for card selection
8. Add validator script for language-sensitive prompts

### Day 5: Testing & Polish
1. Test all screens in both languages
2. Fix any text overflow issues
3. Update tests for localization
4. Add remaining Spanish card translations
5. Final testing and documentation

---

## File Changes Summary

### New Files (6)
- `l10n.yaml`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_es.arb`
- `lib/presentation/state/locale_provider.dart`
- Generated: `lib/l10n/app_localizations.dart`
- `scripts/flag_language_sensitive_cards.py`

### Modified Files (20+)
- `pubspec.yaml`
- `lib/app.dart`
- `lib/domain/entities/card_item.dart`
- `assets/cards.json`
- 13 screen/widget files (listed in Phase 4)
- `lib/data/repositories/cards_repository.dart`
- `lib/presentation/state/game_state_provider.dart`

---

## Success Criteria

- [ ] App supports English and Spanish languages
- [ ] Language can be changed from Settings
- [ ] Language preference persists between sessions
- [ ] All UI text is translated
- [x] Spanish translations added for all cards
- [ ] Language scope flags applied to any language-dependent prompts
- [ ] No text overflow or layout issues
- [ ] All existing tests pass
- [x] New localization tests added

---

## Next Steps

1. Tag any language-dependent cards with `languageScope: ["en"]` or `["es"]`.
2. Add localization tests (at least one widget test for Spanish UI).
3. Run a UI pass in Spanish to check layout/overflow.

## Notes

- Spanish text is typically 20-30% longer than English - verify all UI still fits
- Some card answers may be the same in both languages (e.g., brand names, proper nouns)
- Consider RTL support structure for future Arabic/Hebrew support
- The `flutter gen-l10n` command must be run after ARB file changes
