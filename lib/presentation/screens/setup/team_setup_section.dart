import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/widgets/common/team_color_picker.dart';

/// Team setup section for setup screen
///
/// Displays dynamic team input cards based on number of teams selected.
/// Each team card allows:
/// - Team name input (with localized default names)
/// - Team color selection (must be unique across teams)
/// - Validation for non-empty and unique names
class TeamSetupSection extends StatelessWidget {
  const TeamSetupSection({
    super.key,
    required this.teams,
    required this.onTeamNameChanged,
    required this.onTeamColorChanged,
    this.nameErrors = const {},
  });

  final List<Team> teams;
  final Function(int index, String name) onTeamNameChanged;
  final Function(int index, Color color) onTeamColorChanged;
  final Map<int, String?> nameErrors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: l10n.teamSetup),
        const SizedBox(height: 16),
        ...List.generate(
          teams.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _TeamCard(
              team: teams[index],
              index: index,
              unavailableColors: teams
                  .where((t) => t.id != teams[index].id)
                  .map((t) => t.color)
                  .toList(),
              onNameChanged: (name) => onTeamNameChanged(index, name),
              onColorChanged: (color) => onTeamColorChanged(index, color),
              errorText: nameErrors[index],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: context.palette.textPrimary,
      ),
    );
  }
}

class _TeamCard extends StatefulWidget {
  const _TeamCard({
    required this.team,
    required this.index,
    required this.unavailableColors,
    required this.onNameChanged,
    required this.onColorChanged,
    this.errorText,
  });

  final Team team;
  final int index;
  final List<Color> unavailableColors;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<Color> onColorChanged;
  final String? errorText;

  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.team.name);
  }

  @override
  void didUpdateWidget(_TeamCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if team name changed externally
    if (oldWidget.team.name != widget.team.name &&
        _controller.text != widget.team.name) {
      _controller.text = widget.team.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.team.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.team.color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.teamWithNumber(widget.index + 1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.palette.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Team Name Input
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: l10n.teamName,
                hintText: l10n.enterTeamName,
                errorText: widget.errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.people),
              ),
              onChanged: widget.onNameChanged,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Color Picker Label
            Text(
              l10n.teamColor,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.palette.textSecondary,
              ),
            ),
            const SizedBox(height: 8),

            // Color Picker
            TeamColorPicker(
              selectedColor: widget.team.color,
              onColorSelected: widget.onColorChanged,
              unavailableColors: widget.unavailableColors,
            ),
          ],
        ),
      ),
    );
  }
}
