import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/state/cards_provider.dart';

/// Dialog for selecting a card to report an issue with
class CardSelectorDialog extends ConsumerStatefulWidget {
  const CardSelectorDialog({
    super.key,
    required this.onCardSelected,
  });

  /// Callback when a card is selected
  final ValueChanged<CardItem> onCardSelected;

  @override
  ConsumerState<CardSelectorDialog> createState() => _CardSelectorDialogState();
}

class _CardSelectorDialogState extends ConsumerState<CardSelectorDialog> {
  String _searchQuery = '';
  Difficulty? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cardsAsync = ref.watch(cardsProvider);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.selectCard,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Search and filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search field
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchCards,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Difficulty filter
                  Row(
                    children: [
                      Text(
                        l10n.filterByDifficulty,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          children: [
                            _DifficultyChip(
                              label: l10n.all,
                              isSelected: _selectedDifficulty == null,
                              onSelected: () {
                                setState(() {
                                  _selectedDifficulty = null;
                                });
                              },
                            ),
                            ...Difficulty.values.map((diff) {
                              return _DifficultyChip(
                                label: _getDifficultyLabel(l10n, diff),
                                isSelected: _selectedDifficulty == diff,
                                color: _getDifficultyColor(diff),
                                onSelected: () {
                                  setState(() {
                                    _selectedDifficulty = diff;
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Card list
            Expanded(
              child: cardsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    l10n.errorLoadingCards,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
                data: (cards) {
                  final filteredCards = _filterCards(cards);

                  if (filteredCards.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noCardsFound,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredCards.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      return _CardListTile(
                        card: card,
                        onTap: () => widget.onCardSelected(card),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CardItem> _filterCards(List<CardItem> cards) {
    return cards.where((card) {
      // Filter by difficulty
      if (_selectedDifficulty != null &&
          card.difficulty != _selectedDifficulty) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final promptMatch = card.promptEn.toLowerCase().contains(_searchQuery);
        final answerMatch = card.answersEn
            .any((a) => a.toLowerCase().contains(_searchQuery));
        if (!promptMatch && !answerMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  String _getDifficultyLabel(AppLocalizations l10n, Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return l10n.easy;
      case Difficulty.medium:
        return l10n.medium;
      case Difficulty.hard:
        return l10n.hard;
    }
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return AppColors.success;
      case Difficulty.medium:
        return AppColors.warning;
      case Difficulty.hard:
        return AppColors.error;
    }
  }
}

/// Chip for filtering by difficulty
class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : chipColor,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: chipColor,
      backgroundColor: chipColor.withValues(alpha: 0.1),
      side: BorderSide(color: chipColor),
      checkmarkColor: Colors.white,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// List tile for a card
class _CardListTile extends StatelessWidget {
  const _CardListTile({
    required this.card,
    required this.onTap,
  });

  final CardItem card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Difficulty badge
            _DifficultyBadge(difficulty: card.difficulty),
            const SizedBox(width: 12),
            // Card info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.promptEn,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${card.answersEn.length} answers',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small badge showing difficulty
class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      Difficulty.easy => AppColors.success,
      Difficulty.medium => AppColors.warning,
      Difficulty.hard => AppColors.error,
    };

    return Container(
      width: 8,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
