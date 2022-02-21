import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart' as k;
import 'package:provider/provider.dart';

import '../models/models.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    Key? key,
    required this.onEasy,
    required this.onNormal,
    required this.onHard,
  }) : super(key: key);

  final VoidCallback onEasy;
  final VoidCallback onNormal;
  final VoidCallback onHard;

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
          surfaceColor: k.lightGreen,
          sideColor: k.green,
          textColor: k.darkGreen,
          onPressed: () {
            onEasy();
            // context.read<GameModel>().setDifficulty(Difficulty.simple);
            // context.read<GameBoardModel>().generateGameBoxes(gridSize: 2);
          },
        ),
        const SizedBox(width: 12),
        _DifficultyButton(
          text: 'Normal',
          isSelected: difficulty == Difficulty.medium,
          surfaceColor: k.lightBlue,
          sideColor: k.blue,
          textColor: k.darkBlue,
          onPressed: () {
            onNormal();
            // context.read<GameModel>().setDifficulty(Difficulty.medium);
            // context.read<GameBoardModel>().generateGameBoxes(gridSize: 3);
          },
        ),
        const SizedBox(width: 12),
        _DifficultyButton(
          text: 'Hard',
          isSelected: difficulty == Difficulty.hard,
          surfaceColor: k.lightPurple,
          sideColor: k.purple,
          textColor: k.darkPurple,
          onPressed: () {
            onHard();
            // context.read<GameModel>().setDifficulty(Difficulty.hard);
            // context.read<GameBoardModel>().generateGameBoxes(gridSize: 4);
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
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final Color surfaceColor;
  final Color sideColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double elevation = isSelected ? 0 : 4;
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: elevation, end: elevation),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        builder: (_, double value, child) {
          return Transform.translate(
            offset: Offset(0, -value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xEE222222),
                      offset: Offset(0, value + 2),
                      blurRadius: value + 2,
                      blurStyle: BlurStyle.outer),
                  BoxShadow(
                    color: sideColor,
                    offset: Offset(0, value + 2),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: Text(
          text,
          style: isSelected
              ? const TextStyle(
                  color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600)
              : TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
