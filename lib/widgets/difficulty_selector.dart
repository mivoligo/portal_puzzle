import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final difficulty = context.select<GameModel, Difficulty>(
      (model) => model.difficulty,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DifficultyButton(
          text: 'Simple',
          isSelected: difficulty == Difficulty.simple,
          surfaceColor: const Color(0xFF22C55E),
          sideColor: const Color(0xFF166534),
          textColor: const Color(0xFF14532D),
          onPressed: () =>
              context.read<GameModel>().setDifficulty(Difficulty.simple),
        ),
        const SizedBox(width: 12),
        _DifficultyButton(
          text: 'Medium',
          isSelected: difficulty == Difficulty.medium,
          surfaceColor: const Color(0xFF3B82F6),
          sideColor: const Color(0xFF1E40AF),
          textColor: const Color(0xFF1E3A8A),
          onPressed: () =>
              context.read<GameModel>().setDifficulty(Difficulty.medium),
        ),
        const SizedBox(width: 12),
        _DifficultyButton(
          text: 'Hard',
          isSelected: difficulty == Difficulty.hard,
          surfaceColor: const Color(0xFF8B5CF6),
          sideColor: const Color(0xFF5B21B6),
          textColor: const Color(0xFF4C1D95),
          onPressed: () =>
              context.read<GameModel>().setDifficulty(Difficulty.hard),
        ),
      ],
    );
  }
}

class _DifficultyButton extends StatefulWidget {
  const _DifficultyButton({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.surfaceColor,
    required this.sideColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final Color surfaceColor;
  final Color sideColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  State<_DifficultyButton> createState() => _DifficultyButtonState();
}

class _DifficultyButtonState extends State<_DifficultyButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.onPressed(),
      child: Transform.translate(
        offset: widget.isSelected ? const Offset(0, 4) : const Offset(0, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.surfaceColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xEE222222),
                  offset: widget.isSelected
                      ? const Offset(0, 2)
                      : const Offset(0, 6),
                  blurRadius: widget.isSelected ? 2 : 8,
                  blurStyle: BlurStyle.outer),
              BoxShadow(
                color: widget.sideColor,
                offset:
                    widget.isSelected ? const Offset(0, 2) : const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: widget.isSelected
                ? const TextStyle(
                    color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600)
                : TextStyle(
                    color: widget.textColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
