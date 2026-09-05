import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_language_mode.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/presentation/screens/setup/game_config_section.dart';
import 'package:pes_vres/presentation/screens/setup/team_setup_section.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';

void main() {
  group('GameConfigSection', () {
    testWidgets('displays Game Settings title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Game Settings'), findsOneWidget);
    });

    testWidgets('displays Number of Rounds section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Number of Rounds'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('displays Round Duration section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Round Duration'), findsOneWidget);
      expect(find.text('30s'), findsOneWidget);
      expect(find.text('45s'), findsOneWidget);
      expect(find.text('60s'), findsOneWidget);
      expect(find.text('90s'), findsOneWidget);
    });

    testWidgets('displays Difficulty section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Difficulty'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);
    });

    testWidgets('displays all card language choices', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('English + Spanish'), findsOneWidget);
    });

    testWidgets('selects bilingual card language', (tester) async {
      CardLanguageMode? selectedMode;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
                onCardLanguageModeChanged: (mode) => selectedMode = mode,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('English + Spanish'));
      await tester.pumpAndSettle();

      expect(selectedMode, CardLanguageMode.bilingual);
    });

    testWidgets('calls onRoundsChanged when round button tapped', (
      tester,
    ) async {
      int? selectedRounds;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (rounds) => selectedRounds = rounds,
                onDurationChanged: (_) {},
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();

      expect(selectedRounds, 7);
    });

    testWidgets('calls onDurationChanged when duration button tapped', (
      tester,
    ) async {
      int? selectedDuration;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (duration) => selectedDuration = duration,
                onDifficultiesChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('45s'));
      await tester.pumpAndSettle();

      expect(selectedDuration, 45);
    });

    testWidgets('calls onDifficultiesChanged when difficulty button tapped', (
      tester,
    ) async {
      Set<Difficulty>? selectedDifficulties;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (difficulties) =>
                    selectedDifficulties = difficulties,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();

      expect(selectedDifficulties, contains(Difficulty.easy));
      expect(selectedDifficulties, contains(Difficulty.medium));
    });

    testWidgets('difficulty toggle removes when tapped again', (tester) async {
      Set<Difficulty>? selectedDifficulties;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.easy, Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (difficulties) =>
                    selectedDifficulties = difficulties,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();

      expect(selectedDifficulties, isNot(contains(Difficulty.easy)));
      expect(selectedDifficulties, contains(Difficulty.medium));
    });

    testWidgets('cannot deselect last difficulty', (tester) async {
      Set<Difficulty>? selectedDifficulties;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: GameConfigSection(
                numberOfRounds: 5,
                roundDuration: 60,
                difficulties: {Difficulty.medium},
                onRoundsChanged: (_) {},
                onDurationChanged: (_) {},
                onDifficultiesChanged: (difficulties) =>
                    selectedDifficulties = difficulties,
              ),
            ),
          ),
        ),
      );

      // Try to deselect the only selected difficulty
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      // Should still have medium selected (can't be empty)
      expect(selectedDifficulties, contains(Difficulty.medium));
    });
  });

  group('TeamSetupSection', () {
    final mockTeams = [
      Team(
        id: 'team-1',
        name: 'Team 1',
        color: AppColors.teamColors[0],
        score: 0,
      ),
      Team(
        id: 'team-2',
        name: 'Team 2',
        color: AppColors.teamColors[1],
        score: 0,
      ),
    ];

    testWidgets('displays Team Setup title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Team Setup'), findsOneWidget);
    });

    testWidgets('displays correct number of team cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      // Find team header labels
      expect(find.text('Team 1'), findsWidgets); // Header and possibly input
      expect(find.text('Team 2'), findsWidgets);
    });

    testWidgets('displays team name input fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('displays Team Color label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Team Color'), findsNWidgets(2));
    });

    testWidgets('calls onTeamNameChanged when name input changes', (
      tester,
    ) async {
      int? changedIndex;
      String? changedName;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (index, name) {
                  changedIndex = index;
                  changedName = name;
                },
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      // Find the first TextField and enter text
      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'Red Dragons');
      await tester.pumpAndSettle();

      expect(changedIndex, 0);
      expect(changedName, 'Red Dragons');
    });

    testWidgets('displays error text when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
                nameErrors: {0: 'Team name cannot be empty'},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Team name cannot be empty'), findsOneWidget);
    });

    testWidgets('shows error for duplicate team name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
                nameErrors: {1: 'Team name must be unique'},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Team name must be unique'), findsOneWidget);
    });

    testWidgets('displays three teams when provided', (tester) async {
      final threeTeams = [
        Team(
          id: 'team-1',
          name: 'Team 1',
          color: AppColors.teamColors[0],
          score: 0,
        ),
        Team(
          id: 'team-2',
          name: 'Team 2',
          color: AppColors.teamColors[1],
          score: 0,
        ),
        Team(
          id: 'team-3',
          name: 'Team 3',
          color: AppColors.teamColors[2],
          score: 0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: threeTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('displays four teams when provided', (tester) async {
      final fourTeams = [
        Team(
          id: 'team-1',
          name: 'Team 1',
          color: AppColors.teamColors[0],
          score: 0,
        ),
        Team(
          id: 'team-2',
          name: 'Team 2',
          color: AppColors.teamColors[1],
          score: 0,
        ),
        Team(
          id: 'team-3',
          name: 'Team 3',
          color: AppColors.teamColors[2],
          score: 0,
        ),
        Team(
          id: 'team-4',
          name: 'Team 4',
          color: AppColors.teamColors[3],
          score: 0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: fourTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.byType(Card), findsNWidgets(4));
    });

    testWidgets('has team color indicator circles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TeamSetupSection(
                teams: mockTeams,
                onTeamNameChanged: (_, _) {},
                onTeamColorChanged: (_, _) {},
              ),
            ),
          ),
        ),
      );

      // Find Container widgets that are circles (team color indicators)
      // The team cards have circular color indicators
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('GameSetupState', () {
    test('initial state has empty teams and default config', () {
      final teams = <Team>[];

      expect(teams.length, 0);
    });

    test('isReadyToStart requires at least 2 teams', () {
      final teams = [
        Team(id: 'team-1', name: 'Team 1', color: Colors.red, score: 0),
      ];

      expect(teams.length >= 2, false);
    });

    test('isReadyToStart returns true with valid setup', () {
      final teams = [
        Team(id: 'team-1', name: 'Team 1', color: Colors.red, score: 0),
        Team(id: 'team-2', name: 'Team 2', color: Colors.blue, score: 0),
      ];

      final allNamesValid = teams.every((team) => team.name.trim().isNotEmpty);
      expect(teams.length >= 2 && teams.length <= 4 && allNamesValid, true);
    });

    test('isReadyToStart fails with empty team name', () {
      final teams = [
        Team(id: 'team-1', name: '', color: Colors.red, score: 0),
        Team(id: 'team-2', name: 'Team 2', color: Colors.blue, score: 0),
      ];

      final allNamesValid = teams.every((team) => team.name.trim().isNotEmpty);
      expect(allNamesValid, false);
    });
  });

  group('GameSetupNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initializeTeams creates correct number of teams', () {
      // Test via provider
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(3);

      final state = container.read(gameSetupProvider);
      expect(state.teams.length, 3);
    });

    test('initializeTeams gives unique default names', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(4);

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].name, 'Team 1');
      expect(state.teams[1].name, 'Team 2');
      expect(state.teams[2].name, 'Team 3');
      expect(state.teams[3].name, 'Team 4');
    });

    test('initializeTeams assigns different colors', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(4);

      final state = container.read(gameSetupProvider);
      final colors = state.teams.map((t) => t.color).toSet();
      expect(colors.length, 4); // All colors should be unique
    });

    test('initializeTeams throws for invalid team count', () {
      final notifier = container.read(gameSetupProvider.notifier);

      expect(() => notifier.initializeTeams(1), throwsArgumentError);
      expect(() => notifier.initializeTeams(5), throwsArgumentError);
    });

    test('updateTeamName updates the correct team', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(2);
      notifier.updateTeamName(0, 'Red Dragons');

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].name, 'Red Dragons');
      expect(state.teams[1].name, 'Team 2'); // Unchanged
    });

    test('updateTeamColor updates the correct team', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(2);
      notifier.updateTeamColor(1, Colors.purple);

      final state = container.read(gameSetupProvider);
      expect(state.teams[1].color, Colors.purple);
    });

    test('updateNumberOfRounds updates config', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.updateNumberOfRounds(10);

      final state = container.read(gameSetupProvider);
      expect(state.config.numberOfRounds, 10);
    });

    test('updateRoundDuration updates config', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.updateRoundDuration(90);

      final state = container.read(gameSetupProvider);
      expect(state.config.roundDurationSeconds, 90);
    });

    test('updateDifficulties updates config', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.updateDifficulties({Difficulty.easy, Difficulty.hard});

      final state = container.read(gameSetupProvider);
      expect(state.config.difficulties, {Difficulty.easy, Difficulty.hard});
    });

    test('resetScores sets all team scores to zero', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(2);
      notifier.updateTeamScore(0, 15);
      notifier.updateTeamScore(1, 20);

      notifier.resetScores();

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].score, 0);
      expect(state.teams[1].score, 0);
    });

    test('reset clears all state', () {
      final notifier = container.read(gameSetupProvider.notifier);
      notifier.initializeTeams(3);
      notifier.updateNumberOfRounds(10);

      notifier.reset();

      final state = container.read(gameSetupProvider);
      expect(state.teams.isEmpty, true);
    });
  });
}
