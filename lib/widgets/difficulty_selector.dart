import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal_puzzle/game_model.dart';

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
          onPressed: () =>
              context.read<GameModel>().setDifficulty(Difficulty.simple),
        ),
        _DifficultyButton(
          text: 'Medium',
          isSelected: difficulty == Difficulty.medium,
          onPressed: () =>
              context.read<GameModel>().setDifficulty(Difficulty.medium),
        ),
        _DifficultyButton(
          text: 'Hard',
          isSelected: difficulty == Difficulty.hard,
          onPressed: () =>
              context.read<GameModel>().setDifficulty(Difficulty.hard),
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
    required this.onPressed,
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: isSelected
            ? const TextStyle(color: Colors.orange)
            : const TextStyle(color: Colors.grey),
      ),
      onPressed: onPressed,
    );
  }
}
