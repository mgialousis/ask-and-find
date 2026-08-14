import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// Widget for editing a list of answers dynamically
///
/// Allows users to:
/// - Add new answers (up to 10)
/// - Remove existing answers (minimum 10)
/// - Reorder answers via drag and drop
class AnswerListEditor extends StatefulWidget {
  const AnswerListEditor({
    super.key,
    required this.answers,
    required this.onAnswersChanged,
    this.minAnswers = 10,
    this.maxAnswers = 10,
  });

  /// Current list of answers
  final List<String> answers;

  /// Callback when answers are changed
  final ValueChanged<List<String>> onAnswersChanged;

  /// Minimum number of answers required
  final int minAnswers;

  /// Maximum number of answers allowed
  final int maxAnswers;

  @override
  State<AnswerListEditor> createState() => _AnswerListEditorState();
}

class _AnswerListEditorState extends State<AnswerListEditor> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers = widget.answers.map((a) => TextEditingController(text: a)).toList();
    _focusNodes = List.generate(widget.answers.length, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(AnswerListEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the answers list changed externally, update controllers
    if (widget.answers.length != _controllers.length) {
      _disposeControllers();
      _initializeControllers();
    }
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _addAnswer() {
    if (widget.answers.length >= widget.maxAnswers) return;

    final newAnswers = List<String>.from(widget.answers)..add('');
    widget.onAnswersChanged(newAnswers);

    // Add controller and focus node
    _controllers.add(TextEditingController());
    _focusNodes.add(FocusNode());

    // Focus the new field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes.last.requestFocus();
      }
    });
  }

  void _removeAnswer(int index) {
    if (widget.answers.length <= widget.minAnswers) return;

    final newAnswers = List<String>.from(widget.answers)..removeAt(index);
    widget.onAnswersChanged(newAnswers);

    // Remove controller and focus node
    _controllers[index].dispose();
    _controllers.removeAt(index);
    _focusNodes[index].dispose();
    _focusNodes.removeAt(index);
  }

  void _updateAnswer(int index, String value) {
    final newAnswers = List<String>.from(widget.answers);
    newAnswers[index] = value;
    widget.onAnswersChanged(newAnswers);
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final newAnswers = List<String>.from(widget.answers);
    final item = newAnswers.removeAt(oldIndex);
    newAnswers.insert(newIndex, item);
    widget.onAnswersChanged(newAnswers);

    // Also reorder controllers and focus nodes
    final controller = _controllers.removeAt(oldIndex);
    _controllers.insert(newIndex, controller);
    final focusNode = _focusNodes.removeAt(oldIndex);
    _focusNodes.insert(newIndex, focusNode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canAdd = widget.answers.length < widget.maxAnswers;
    final canRemove = widget.answers.length > widget.minAnswers;

    // Count non-empty answers
    final filledCount = widget.answers.where((a) => a.isNotEmpty).length;
    final isValid = filledCount >= widget.minAnswers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Answer count indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isValid
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.info,
                size: 16,
                color: isValid ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.answersCount(filledCount, widget.minAnswers),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isValid ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Answer list
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.answers.length,
          onReorder: _onReorder,
          buildDefaultDragHandles: false,
          itemBuilder: (context, index) {
            return _AnswerItem(
              key: ValueKey('answer_$index'),
              index: index,
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              onChanged: (value) => _updateAnswer(index, value),
              onRemove: canRemove ? () => _removeAnswer(index) : null,
            );
          },
        ),
        const SizedBox(height: 12),

        // Add button
        if (canAdd)
          OutlinedButton.icon(
            onPressed: _addAnswer,
            icon: const Icon(Icons.add),
            label: Text(l10n.addAnswer),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
      ],
    );
  }
}

/// Single answer item in the list
class _AnswerItem extends StatelessWidget {
  const _AnswerItem({
    super.key,
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onRemove,
  });

  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Drag handle
          ReorderableDragStartListener(
            index: index,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.drag_handle,
                color: context.palette.textSecondary,
                size: 20,
              ),
            ),
          ),
          // Answer number
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.palette.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.palette.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Text field
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: const OutlineInputBorder(),
                hintText: 'Answer ${index + 1}',
              ),
              maxLength: 100,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              onChanged: onChanged,
            ),
          ),
          // Remove button
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.error,
              iconSize: 20,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
