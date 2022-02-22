import 'package:flutter/material.dart';
import 'package:portal_puzzle/constants.dart' as k;
import 'package:portal_puzzle/widgets/widgets.dart';
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
        HeroButton(
          label: 'Easy',
          isSelected: difficulty == Difficulty.simple,
          surfaceColor: k.lightGreen,
          sideColor: k.green,
          textColor: k.darkGreen,
          onPressed: onEasy,
        ),
        const SizedBox(width: 12),
        HeroButton(
          label: 'Normal',
          isSelected: difficulty == Difficulty.medium,
          surfaceColor: k.lightBlue,
          sideColor: k.blue,
          textColor: k.darkBlue,
          onPressed: onNormal,
        ),
        const SizedBox(width: 12),
        HeroButton(
          label: 'Hard',
          isSelected: difficulty == Difficulty.hard,
          surfaceColor: k.lightPurple,
          sideColor: k.purple,
          textColor: k.darkPurple,
          onPressed: onHard,
        ),
      ],
    );
  }
}
