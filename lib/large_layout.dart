import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_board.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

class LargeLayout extends StatelessWidget {
  const LargeLayout({
    Key? key,
    required this.animationController,
    required this.onEasy,
    required this.onNormal,
    required this.onHard,
  }) : super(key: key);

  final AnimationController animationController;
  final VoidCallback onEasy;
  final VoidCallback onNormal;
  final VoidCallback onHard;

  @override
  Widget build(BuildContext context) {
    final difficulty = context.select<GameModel, Difficulty>(
      (model) => model.difficulty,
    );
    final gridSize = context.select<GameModel, int>((model) => model.gridSize);
    final status = context.select<GameModel, Status>((model) => model.status);

    String difficultyString;

    switch (difficulty) {
      case Difficulty.easy:
        difficultyString = 'Easy';
        break;
      case Difficulty.normal:
        difficultyString = 'Normal';
        break;
      case Difficulty.hard:
        difficultyString = 'Hard';
        break;
    }

    return Stack(
      children: [
        if (status != Status.finished)
          Positioned(
            top: 64,
            right: 64,
            child: DifficultySelector(
              onEasy: onEasy,
              onNormal: onNormal,
              onHard: onHard,
            ),
          ),
        if (status == Status.initial)
          const Positioned(left: 124, top: 360, child: Bubbles()),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: SingleChildScrollView(
              child: SizedBox(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppTitle(isLarge: true),
                    const SizedBox(height: 24),
                    if (status != Status.finished)
                      Text(
                        'Difficulty: $difficultyString',
                        style: const TextStyle(fontSize: 24),
                      ),
                    const SizedBox(height: 24),
                    if (status != Status.finished)
                      const MovesCounter(isLarge: true),
                    if (status == Status.finished) const SolvedMessage(),
                    const SizedBox(height: 24),
                    if (status == Status.finished) const SizedBox(height: 10),
                    ShuffleButton(
                      onPressed: () async {
                        await context.read<GameBoardModel>().shuffle(gridSize);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GameBoard(
              animationController: animationController,
              parentSize: constraints.biggest.shortestSide * 0.6,
            );
          },
        ),
      ],
    );
  }
}
