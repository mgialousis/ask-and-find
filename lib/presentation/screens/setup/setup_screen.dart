import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/analytics/analytics_service.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_language_mode.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/domain/entities/game_config.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/screens/setup/game_config_section.dart';
import 'package:pes_vres/presentation/screens/setup/team_setup_section.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';
import 'package:pes_vres/presentation/state/game_state_provider.dart';
import 'package:pes_vres/presentation/state/timer_provider.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:uuid/uuid.dart';

/// Setup screen - Configure teams and game settings
///
/// Allows users to:
/// - Select number of teams (2-4)
/// - Customize team names and colors
/// - Configure game settings (rounds, duration, difficulty)
/// - Validates inputs before starting game
///
/// Phase 2: Now uses Riverpod for state management (hybrid approach).
/// Validation logic remains local, but data is synced to provider.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _uuid = const Uuid();
  bool _didScheduleProviderInit = false;
  bool _didSyncDefaultTeams = false;
  bool _didInitializeCardLanguage = false;

  // Team configuration
  int _numberOfTeams = 2;
  List<Team> _teams = [];
  final Map<int, String?> _nameErrors = {};

  // Game configuration
  int _numberOfRounds = 5;
  int _roundDuration = 60;
  Set<Difficulty> _difficulties = {Difficulty.medium};
  CardLanguageMode _cardLanguageMode = CardLanguageMode.english;

  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(gameStateProvider.notifier).reset();
      ref.read(timerProvider.notifier).reset();
      ref.read(gameSetupProvider.notifier).initializeTeams(_numberOfTeams);
      ref
          .read(gameSetupProvider.notifier)
          .updateConfig(
            GameConfig(
              numberOfRounds: _numberOfRounds,
              roundDurationSeconds: _roundDuration,
              difficulties: _difficulties,
              cardLanguageMode: _cardLanguageMode,
            ),
          );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitializeCardLanguage) {
      _cardLanguageMode = Localizations.localeOf(context).languageCode == 'es'
          ? CardLanguageMode.spanish
          : CardLanguageMode.english;
      _didInitializeCardLanguage = true;
    }
    if (_teams.isEmpty) {
      _initializeTeams();
    }
  }

  /// Initialize teams with default names and colors
  void _initializeTeams() {
    final l10n = AppLocalizations.of(context);
    _teams = List.generate(
      _numberOfTeams,
      (index) => Team(
        id: _uuid.v4(),
        name: l10n.teamWithNumber(index + 1),
        color: AppColors.teamColors[index % AppColors.teamColors.length],
        score: 0,
      ),
    );
  }

  /// Handle team number change (2-4 teams)
  void _onTeamNumberChanged(int newNumber) {
    setState(() {
      _numberOfTeams = newNumber;
      final l10n = AppLocalizations.of(context);

      if (newNumber > _teams.length) {
        // Add new teams
        final teamsToAdd = newNumber - _teams.length;
        for (int i = 0; i < teamsToAdd; i++) {
          final index = _teams.length;
          _teams.add(
            Team(
              id: _uuid.v4(),
              name: l10n.teamWithNumber(index + 1),
              color: AppColors.teamColors[index % AppColors.teamColors.length],
              score: 0,
            ),
          );
        }
      } else if (newNumber < _teams.length) {
        // Remove excess teams
        _teams = _teams.sublist(0, newNumber);
        // Clear errors for removed teams
        _nameErrors.removeWhere((key, value) => key >= newNumber);
      }

      // Sync to provider
      ref.read(gameSetupProvider.notifier).initializeTeams(newNumber);
      // Update provider teams to match local state (with current names/colors)
      for (int i = 0; i < _teams.length; i++) {
        ref.read(gameSetupProvider.notifier).updateTeam(i, _teams[i]);
      }
    });
  }

  /// Handle team name change
  void _onTeamNameChanged(int index, String name) {
    setState(() {
      _teams[index] = _teams[index].copyWith(name: name);
      _validateTeamName(index, name);

      // Sync to provider
      ref.read(gameSetupProvider.notifier).updateTeamName(index, name);
    });
  }

  /// Handle team color change
  void _onTeamColorChanged(int index, Color color) {
    setState(() {
      _teams[index] = _teams[index].copyWith(color: color);

      // Sync to provider
      ref.read(gameSetupProvider.notifier).updateTeamColor(index, color);
    });
  }

  /// Validate team name (non-empty and unique)
  void _validateTeamName(int index, String name) {
    final l10n = AppLocalizations.of(context);

    if (name.trim().isEmpty) {
      _nameErrors[index] = l10n.validationNameEmpty;
      return;
    }

    // Check for duplicate names
    final duplicateIndex = _teams.indexWhere(
      (team) =>
          team.name.trim().toLowerCase() == name.trim().toLowerCase() &&
          _teams.indexOf(team) != index,
    );

    if (duplicateIndex != -1) {
      _nameErrors[index] = l10n.validationNameDuplicate;
      return;
    }

    // Name is valid
    _nameErrors.remove(index);
  }

  /// Validate all teams before starting game
  bool _validateAllTeams() {
    final l10n = AppLocalizations.of(context);
    bool isValid = true;

    for (int i = 0; i < _teams.length; i++) {
      final name = _teams[i].name.trim();

      if (name.isEmpty) {
        setState(() {
          _nameErrors[i] = l10n.validationNameEmpty;
        });
        isValid = false;
        continue;
      }

      // Check for duplicates
      final duplicateIndex = _teams.indexWhere(
        (team) =>
            team.name.trim().toLowerCase() == name.toLowerCase() &&
            _teams.indexOf(team) != i,
      );

      if (duplicateIndex != -1) {
        setState(() {
          _nameErrors[i] = l10n.validationNameDuplicate;
        });
        isValid = false;
      }
    }

    return isValid;
  }

  /// Start the game
  void _startGame() {
    final l10n = AppLocalizations.of(context);

    if (!_validateAllTeams()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.validationFixErrors),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final setupState = ref.read(gameSetupProvider);
    unawaited(
      AnalyticsService.instance.capture(
        'new_game_started',
        properties: {
          'rounds': setupState.config.numberOfRounds,
          'duration_seconds': setupState.config.roundDurationSeconds,
          'teams_count': setupState.teams.length,
          'difficulties': setupState.config.difficulties
              .map((difficulty) => difficulty.name)
              .toList(),
          'card_language_mode': setupState.config.cardLanguageMode.name,
        },
      ),
    );

    ref.read(gameStateProvider.notifier).reset();
    ref.read(timerProvider.notifier).reset();

    // Provider is already synced with all team and config data
    // Game screen will read from gameSetupProvider
    context.pushNamed('game');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final setupState = ref.watch(gameSetupProvider);

    if (setupState.teams.isEmpty && !_didScheduleProviderInit) {
      _didScheduleProviderInit = true;
      _didSyncDefaultTeams = false;
      Future(() {
        if (!mounted) return;
        ref.read(gameSetupProvider.notifier).initializeTeams(_numberOfTeams);
        ref
            .read(gameSetupProvider.notifier)
            .updateConfig(
              GameConfig(
                numberOfRounds: _numberOfRounds,
                roundDurationSeconds: _roundDuration,
                difficulties: _difficulties,
                cardLanguageMode: _cardLanguageMode,
              ),
            );
      });
    } else if (setupState.teams.isNotEmpty &&
        !_didSyncDefaultTeams &&
        setupState.teams.length == _teams.length &&
        _teams.isNotEmpty) {
      _didSyncDefaultTeams = true;
      Future(() {
        if (!mounted) return;
        final notifier = ref.read(gameSetupProvider.notifier);
        for (int i = 0; i < _teams.length; i++) {
          notifier.updateTeam(i, _teams[i]);
        }
      });
    } else if (setupState.teams.isNotEmpty) {
      _didScheduleProviderInit = false;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gameSetup)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number of Teams Selector
                    Text(
                      l10n.numberOfTeams,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TeamNumberSelector(
                      selectedNumber: _numberOfTeams,
                      onChanged: _onTeamNumberChanged,
                    ),
                    const SizedBox(height: 32),

                    // Team Setup Section
                    TeamSetupSection(
                      teams: _teams,
                      onTeamNameChanged: _onTeamNameChanged,
                      onTeamColorChanged: _onTeamColorChanged,
                      nameErrors: _nameErrors,
                    ),
                    const SizedBox(height: 32),

                    // Game Configuration Section
                    GameConfigSection(
                      numberOfRounds: _numberOfRounds,
                      roundDuration: _roundDuration,
                      difficulties: _difficulties,
                      cardLanguageMode: _cardLanguageMode,
                      onRoundsChanged: (rounds) {
                        setState(() {
                          _numberOfRounds = rounds;
                        });
                        // Sync to provider
                        ref
                            .read(gameSetupProvider.notifier)
                            .updateNumberOfRounds(rounds);
                      },
                      onDurationChanged: (duration) {
                        setState(() {
                          _roundDuration = duration;
                        });
                        // Sync to provider
                        ref
                            .read(gameSetupProvider.notifier)
                            .updateRoundDuration(duration);
                      },
                      onDifficultiesChanged: (difficulties) {
                        setState(() {
                          _difficulties = difficulties;
                        });
                        // Sync to provider
                        ref
                            .read(gameSetupProvider.notifier)
                            .updateDifficulties(difficulties);
                      },
                      onCardLanguageModeChanged: (mode) {
                        setState(() {
                          _cardLanguageMode = mode;
                        });
                        ref
                            .read(gameSetupProvider.notifier)
                            .updateCardLanguageMode(mode);
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Start Game Button (Fixed at bottom)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.palette.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: PrimaryButton(
                onPressed: _startGame,
                isFullWidth: true,
                child: Text(l10n.startGame),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamNumberSelector extends StatelessWidget {
  const _TeamNumberSelector({
    required this.selectedNumber,
    required this.onChanged,
  });

  final int selectedNumber;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _NumberButton(
            number: 2,
            label: l10n.teams,
            isSelected: selectedNumber == 2,
            onTap: () => onChanged(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _NumberButton(
            number: 3,
            label: l10n.teams,
            isSelected: selectedNumber == 3,
            onTap: () => onChanged(3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _NumberButton(
            number: 4,
            label: l10n.teams,
            isSelected: selectedNumber == 4,
            onTap: () => onChanged(4),
          ),
        ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({
    required this.number,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final int number;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : context.palette.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 4 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : context.palette.surfaceVariant,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$number',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : context.palette.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.9)
                      : context.palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
