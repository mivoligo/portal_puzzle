import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart' as k;
import '../models/models.dart';
import 'widgets.dart';

class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    super.key,
    required this.onEasy,
    required this.onNormal,
    required this.onHard,
  });

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
        FancyButton(
          label: 'Easy',
          isSelected: difficulty == Difficulty.easy,
          surfaceColor: k.lightGreen,
          sideColor: k.green,
          textColor: k.darkGreen,
          onPressed: onEasy,
        ),
        const SizedBox(width: 12),
        FancyButton(
          label: 'Normal',
          isSelected: difficulty == Difficulty.normal,
          surfaceColor: k.lightBlue,
          sideColor: k.blue,
          textColor: k.darkBlue,
          onPressed: onNormal,
        ),
        const SizedBox(width: 12),
        FancyButton(
          label: 'Hard',
          isSelected: difficulty == Difficulty.hard,
          surfaceColor: k.lightViolet,
          sideColor: k.violet,
          textColor: k.darkViolet,
          onPressed: onHard,
        ),
      ],
    );
  }
}
