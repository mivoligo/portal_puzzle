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
          text: 'Easy',
          isSelected: difficulty == Difficulty.simple,
          surfaceColor: const Color(0xFF22C55E),
          sideColor: const Color(0xFF059669),
          textColor: const Color(0xFF14532D),
          onPressed: () {
            context.read<GameModel>().setDifficulty(Difficulty.simple);
            context.read<GameBoardModel>().generateGameBoxes(gridSize: 2);
          },
        ),
        const SizedBox(width: 12),
        _DifficultyButton(
          text: 'Normal',
          isSelected: difficulty == Difficulty.medium,
          surfaceColor: const Color(0xFF3B82F6),
          sideColor: const Color(0xFF1D4ED8),
          textColor: const Color(0xFF1E3A8A),
          onPressed: () {
            context.read<GameModel>().setDifficulty(Difficulty.medium);
            context.read<GameBoardModel>().generateGameBoxes(gridSize: 3);
          },
        ),
        const SizedBox(width: 12),
        _DifficultyButton(
          text: 'Hard',
          isSelected: difficulty == Difficulty.hard,
          surfaceColor: const Color(0xFF8B5CF6),
          sideColor: const Color(0xFF6D28D9),
          textColor: const Color(0xFF4C1D95),
          onPressed: () {
            context.read<GameModel>().setDifficulty(Difficulty.hard);
            context.read<GameBoardModel>().generateGameBoxes(gridSize: 4);
          },
        ),
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.surfaceColor,
    required this.sideColor,
    required this.textColor,
    required this.onPressed,
    this.isPressed = false,
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final Color surfaceColor;
  final Color sideColor;
  final Color textColor;
  final VoidCallback onPressed;

  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: Transform.translate(
        offset: isSelected ? const Offset(0, 4) : const Offset(0, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xEE222222),
                  offset: isSelected ? const Offset(0, 2) : const Offset(0, 6),
                  blurRadius: isSelected ? 2 : 8,
                  blurStyle: BlurStyle.outer),
              BoxShadow(
                color: sideColor,
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            text,
            style: isSelected
                ? const TextStyle(
                    color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600)
                : TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
