import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class LargeLayout extends StatelessWidget {
  const LargeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final difficulty = context.select<GameModel, Difficulty>(
      (model) => model.difficulty,
    );

    String difficultyString;

    switch (difficulty) {
      case Difficulty.simple:
        difficultyString = 'Simple';
        break;
      case Difficulty.medium:
        difficultyString = 'Medium';
        break;
      case Difficulty.hard:
        difficultyString = 'Hard';
        break;
    }

    return Stack(
      children: [
        const Positioned(
          top: 64,
          right: 64,
          child: DifficultySelector(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 250,
                    child: AppTitle(isLarge: true),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Difficulty: $difficultyString',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  const MovesCounter(
                    isLarge: true,
                  ),
                  const SizedBox(height: 24),
                  const ShuffleButton(),
                ],
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GameBoard(parentSize: constraints.biggest * 0.6);
          },
        ),
      ],
    );
  }
}
